import mongoose from "mongoose";

const SearchHistorySchema = mongoose.Schema(
  {
    Owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Owner is required"],
    },
    search: {
      type: String,
      required: [true, "Search is required"],
    },
    resultIds: {
      type: Array,
      required: [true, "ResultIds is required"],
    },
  },
  { timestamps: true }
);
export const SearchHistory = mongoose.model(
  "SearchHistory",
  SearchHistorySchema
);
