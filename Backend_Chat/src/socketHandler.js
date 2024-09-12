import { Chat } from "./models/chat.models.js";
import { ChatRequests } from "./models/chatRequest.models.js";
import { GroupMembers } from "./models/groupMembers.models.js";

// socketHandler.js
export const socketHandler = (io) => {
  const userSocketMap = new Map(); // Map to keep track of userId and socketId

  io.on("connection", (socket) => {
    console.log("A user connected", socket.id);

    // When a user joins, map their userId to their current socket.id
    socket.on("registerUser", (userId) => {
      if (userId) {
        if (!userSocketMap.has(userId)) {
          userSocketMap.set(userId, socket.id);
          socket.on("registerUserAck", () => {
            socket.emit("userList", Object.fromEntries(userSocketMap));
            console.log(userSocketMap);
          });
        } else {
          console.log("User already registered");
          socket.on("registerUserAck", () => {
            socket.emit("userList", "User already registered");
          });
        }
      } else {
        console.log("User id is not provided", userId);
        socket.on("registerUserAck", () => {
          socket.emit("userList", "User id is not provided");
        });
      }
    });

    // Join a room
    socket.on(
      "createGroup",
      async ({ groupName, description, grpIcon, grpTags, userId }) => {
        try {
          const newGroup = await GroupInfo.create({
            grpName: groupName,
            description,
            grpIcon,
            grpTags,
          });
          await GroupMembers.create({
            groupId: newGroup._id,
            userId,
            isAdmin: true,
          });
          socket.emit("groupCreated", { groupId: newGroup._id });
        } catch (error) {
          console.error("Error creating group:", error);
        }
      }
    );

    socket.on("joinGroup", async ({ groupId, userId }) => {
      try {
        // Check if the user is already a member of the group
        const isMember = await GroupMembers.findOne({ groupId, userId });
        if (!isMember) {
          await GroupMembers.findOneAndDelete({ groupId, userId });
          // Leave the socket from a room named by groupId
          socket.leave(groupId);
          // Emit to the user that they have left the group
          socket.emit("groupLeft", { groupId });
          // Broadcast to all other group members
          socket.to(groupId).emit("userLeftGroup", { userId, groupId });
        } else {
          socket.emit("alreadyInGroup", { groupId });
        }
      } catch (error) {
        console.error("Error joining group:", error);
      }
    });

    // Leave Group
    socket.on("leaveGroup", async ({ groupId, userId }) => {
      try {
        await GroupMembers.findOneAndDelete({ groupId, userId });
        socket.emit("groupLeft", { groupId });
      } catch (error) {
        console.error("Error leaving group:", error);
      }
    });

    // Message in Group
    socket.on("groupMessage", async ({ groupId, userId, message }) => {
      try {
        const newMessage = await Chat.create({
          Owner: userId,
          grpid: groupId,
          message,
        });
        const members = await GroupMembers.find({ groupId: groupId }).select(
          "_id"
        );
        members.forEach((member) => {
          const receiverSocketId = userSocketMap.get(member.userId.toString());
          if (receiverSocketId) {
            io.to(receiverSocketId).emit("newGroupMessage", {
              groupId,
              message: newMessage,
            });
          }
        });
      } catch (error) {
        console.error("Error sending message to group:", error);
      }
    });

    // Leave Group
    socket.on("leaveGroup", async ({ groupId, userId }) => {
      try {
        await GroupMembers.findOneAndDelete({ groupId, userId });
        socket.emit("groupLeft", { groupId });
      } catch (error) {
        console.error("Error leaving group:", error);
      }
    });

    // Message in Group
    socket.on("groupMessage", async ({ groupId, userId, message }) => {
      try {
        const newMessage = await Chat.create({
          Owner: userId,
          grpid: groupId,
          message,
        });
        const members = await GroupMembers.find({ 
          groupId, 
          userId: { $ne: userId } 
        }).select(
          "_id"
        );
        members.forEach((member) => {
          const receiverSocketId = userSocketMap.get(member.userId.toString());
          if (receiverSocketId) {
            io.to(receiverSocketId).emit("newGroupMessage", {
              groupId,
              senderId: userId,
              message: newMessage,
            });
          }
        });
      } catch (error) {
        console.error("Error sending message to group:", error);
      }
    });

    // Handle private message
    socket.on("privateMessage", async (senderId, receiverId, message) => {
      
      console.log(`Message from ${senderId} to ${receiverId}: ${message}`);

      // Use the map to get the receiver's socketId
      const receiverSocketId = userSocketMap.get(receiverId);
      if (1) {
        console.log(`Receiver ${receiverId} found`);
        // socket.emit('newMessage', "Working");


        try {
          const newMessage = new Chat({
            Owner: senderId,
            Recipient: receiverId,
            message: message,
            
            //  this message is not part of a group chat, hence grpid is not set
          });
          await newMessage.save();
          io.to(receiverSocketId).emit("newMessage", newMessage);//req testing

          console.log("Message saved to database");
        } catch (error) {
          console.error("Error saving message to database:", error);
        }
      } else {
        console.log(`Receiver ${receiverId} not found`);
      }
    });

    // Handle sending chat requests
    socket.on("sendChatRequest", async ({ fromUserId, toUserId }) => {
      const receiverSocketId = userSocketMap.get(toUserId);

      if (receiverSocketId) {
        try {
          await ChatRequests.create({
            requester: fromUserId,
            recipient: toUserId,
          });
        } catch (error) {
          console.log(error);
        }
        io.to(receiverSocketId).emit("chatRequest", { fromUserId });
      }
    });

    // Handle accepting chat requests
    socket.on("acceptChatRequest", async ({ fromUserId, toUserId }) => {
      const senderSocketId = userSocketMap.get(fromUserId);
      if (senderSocketId) {
        await  ChatRequests.updateOne(
          { requester: fromUserId, recipient: toUserId },
          { status: "accepted" }
        );
        io.to(senderSocketId).emit("chatRequestAccepted", { toUserId });
      }
    });

    socket.on("declineChatRequest", async ({ fromUserId, toUserId }) => {
      const senderSocketId = userSocketMap.get(fromUserId);
      if (senderSocketId) {
      await  ChatRequests.updateOne(
          { requester: fromUserId, recipient: toUserId },
          { status: "declined" }
        );
        io.to(senderSocketId).emit("chatRequestDeclined", { toUserId });
      }
    });

    // Cleanup on disconnect
    socket.on("disconnect", () => {
      console.log(`User disconnected ${socket.id}`);
      // Remove the user from the map
      const entries = userSocketMap.entries();
      for (let [userId, socketId] of entries) {
        if (socketId === socket.id) {
          userSocketMap.delete(userId);
          break;
        }
      }
    });
  });
};
