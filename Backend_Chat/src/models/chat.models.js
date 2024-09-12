import mongoose from "mongoose";

const chatSchema = mongoose.Schema(
  {
    Owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Owner is required"],
    },
    Recipient: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },
    grpid: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "GroupInfo",
      // required: [true, "Group is required"],
      default: null,
    },
    message: {
      type: String,
      required: [true, "Message is required"],
    },
    filelink: {
      type: String,
      default: null,
    },
  },

  { timestamps: true }
);

export const Chat = mongoose.model("Chat", chatSchema);
