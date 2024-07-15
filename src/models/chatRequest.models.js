import mongoose from "mongoose";

const ChatRequestSchema = mongoose.Schema(
  {
    requester: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
      },
      recipient: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
      },
      status: {
        type: String,
        enum: ["pending", "accepted", "declined"],
        default: "pending",
      },
  },
  { timestamps: true }
);
export const ChatRequests = mongoose.model("ChatRequest", ChatRequestSchema);
