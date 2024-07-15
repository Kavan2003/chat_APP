import mongoose from "mongoose";

const GroupInfoSchema = mongoose.Schema(
  {
    grpName: {
      type: String,
      required: [true, "Group Name is required"],
      unique: true,
    },
    description: {
      type: String,
      required: [true, "Description is required"],
    },

    grpIcon: {
      type: String,
      required: [true, "Group Icon is required"],
    },
    grpTags: {
      type: Array,
      required: [true, "Group Tags is required"],
    },
  },
  { timestamps: true }
);
export const GroupInfo = mongoose.model("GroupInfo", GroupInfoSchema);
