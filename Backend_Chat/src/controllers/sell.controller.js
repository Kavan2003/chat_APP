import { SellItem } from "../models/sell.models.js";
import { uploadFileOnCloudinary } from "../utils/cloudnary.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/AsyncHandler.js";

export const createSellItem = asyncHandler(async (req, res, next) => {
  const { name, description, price } = req.body;
  const owner = req.user._id; // Assuming user ID is stored in req.user

  const imageUrls = await Promise.all(
    req.files.map(async (file) => {
      const result = await uploadFileOnCloudinary(file.path);
      return result.url;
    })
  );

  const newItem = new SellItem({
    Owner: owner,
    images: imageUrls,
    name,
    description,
    price,
  });

  await newItem.save();
  res.status(201).json(new ApiResponse(201, "Sell item created successfully", newItem));
});

export const getAllSellItems = asyncHandler(async (req, res, next) => {
  const items = await SellItem.find().populate("Owner", "username email");
  res.status(200).json(new ApiResponse(200, "Sell items retrieved successfully", items));
});

export const getSellItemById = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const item = await SellItem.findById(id).populate("Owner", "username email");
  if (!item) {
    return next(new ApiError(404, "Sell item not found"));
  }
  res.status(200).json(new ApiResponse(200, "Sell item retrieved successfully", item));
});

export const updateSellItem = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const { name, description, price } = req.body;

  const imageUrls = await Promise.all(
    req.files.map(async (file) => {
      const result = await uploadFileOnCloudinary(file.path);
      return result.url;
    })
  );

  const updatedItem = await SellItem.findByIdAndUpdate(
    id,
    { name, description, price, images: imageUrls },
    { new: true }
  );

  if (!updatedItem) {
    return next(new ApiError(404, "Sell item not found"));
  }

  res.status(200).json(new ApiResponse(200, "Sell item updated successfully", updatedItem));
});

export const deleteSellItem = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const deletedItem = await SellItem.findByIdAndDelete(id);

  if (!deletedItem) {
    return next(new ApiError(404, "Sell item not found"));
  }

  res.status(200).json(new ApiResponse(200, "Sell item deleted successfully", deletedItem));
});

export const uploadImages = asyncHandler(async (req, res, next) => {
  const imageUrls = await Promise.all(
    req.files.map(async (file) => {
      const result = await uploadFileOnCloudinary(file.path);
      return result.url;
    })
  );

  res.status(200).json(new ApiResponse(200, "Images uploaded successfully", { images: imageUrls }));
});