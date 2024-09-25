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
          socket.emit("userList", Object.fromEntries(userSocketMap));
          console.log(userSocketMap);
        } else {
          console.log("User already registered");
          socket.emit("userList", "User already registered");
        }
      } else {
        console.log("User id is not provided", userId);
        socket.emit("userList", "User id is not provided");
      }
    });

    // Join a room
    socket.on("createGroup", async ({ groupName, description, grpIcon, grpTags, userId }) => {
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
    });

    socket.on("joinGroup", async ({ groupId, userId }) => {
      try {
        // Check if the user is already a member of the group
        const isMember = await GroupMembers.findOne({ groupId, userId });
        if (!isMember) {
          await GroupMembers.create({ groupId, userId });
          socket.join(groupId);
          socket.emit("groupJoined", { groupId });
          socket.to(groupId).emit("userJoinedGroup", { userId, groupId });
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
        socket.leave(groupId);
        socket.emit("groupLeft", { groupId });
        socket.to(groupId).emit("userLeftGroup", { userId, groupId });
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
        const members = await GroupMembers.find({ groupId, userId: { $ne: userId } }).select("userId");
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
      const senderSocketId = userSocketMap.get(senderId);
      if (receiverSocketId) {
        console.log(`Receiver ${receiverId} found`);

        try {
          const newMessage = new Chat({
            Owner: senderId,
            Recipient: receiverId,
            message: message,
          });
          await newMessage.save();
          io.to(receiverSocketId).emit("newMessage", newMessage);
          io.to(senderSocketId).emit("sentMessage", newMessage);

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
          io.to(receiverSocketId).emit("chatRequest", { fromUserId });
        } catch (error) {
          console.error("Error sending chat request:", error);
        }
      }
    });

    // Handle accepting chat requests
    socket.on("acceptChatRequest", async ({ fromUserId, toUserId }) => {
      const senderSocketId = userSocketMap.get(fromUserId);
      if (senderSocketId) {
        try {
          await ChatRequests.updateOne(
            { requester: fromUserId, recipient: toUserId },
            { status: "accepted" }
          );
          io.to(senderSocketId).emit("chatRequestAccepted", { toUserId });
        } catch (error) {
          console.error("Error accepting chat request:", error);
        }
      }
    });

    socket.on("declineChatRequest", async ({ fromUserId, toUserId }) => {
      const senderSocketId = userSocketMap.get(fromUserId);
      if (senderSocketId) {
        try {
          await ChatRequests.updateOne(
            { requester: fromUserId, recipient: toUserId },
            { status: "declined" }
          );
          io.to(senderSocketId).emit("chatRequestDeclined", { toUserId });
        } catch (error) {
          console.error("Error declining chat request:", error);
        }
      }
    });

    // Cleanup on disconnect
    socket.on("disconnect", () => {
      console.log(`User disconnected ${socket.id}`);
      for (let [userId, socketId] of userSocketMap.entries()) {
        if (socketId === socket.id) {
          userSocketMap.delete(userId);
          break;
        }
      }
    });
  });
};