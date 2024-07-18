import mongoose from "mongoose";

const GroupMemberSchema = mongoose.Schema(
  {
    groupId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "GroupInfo",
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    isAdmin: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);
export const GroupMembers = mongoose.model("GroupMember", GroupMemberSchema);
