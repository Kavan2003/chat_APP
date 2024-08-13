import mongoose from "mongoose";

const SellItemSchema = mongoose.Schema(
  {
    Owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Owner is required"],
    },
    images: {
      type: [String], // Array of image URLs
      required: [true, "Images are required"],
    },
    name: {
      type: String,
      required: [true, "Name is required"],
    },
    description: {
      type: String,
      required: [true, "Description is required"],
    },
    price: {
      type: Number,
      required: [true, "Price is required"],
    },
  },
  { timestamps: true }
);

export const SellItem = mongoose.model("SellItem", SellItemSchema);