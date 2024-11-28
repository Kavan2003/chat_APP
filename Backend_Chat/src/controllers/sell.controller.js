import { SellItem } from "../models/sell.models.js";
import { uploadFileOnCloudinary } from "../utils/cloudnary.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/AsyncHandler.js";
import Fuse from "fuse.js";

export const createSellItem = asyncHandler(async (req, res, next) => {
  const { name, description, price } = req.body;
  const owner = req.user._id; // Assuming user ID is stored in req.user

if (!name || !description || !price) {
    throw new ApiError(400, "Name, description, and price are required");
  }
 if (!owner) {
    throw new ApiError(401, "Unauthorized");
  }
  if (!req.files || req.files.length === 0) {
    throw new ApiError(400, "Images are required");
  }


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
  const ownernewitems = await SellItem.findById(newItem._id).populate("Owner", "-password -refreshToken");
  res.status(201).json(new ApiResponse(201, "Sell item created successfully", ownernewitems));
});

export const getAllSellItems = asyncHandler(async (req, res, next) => {
  const {keyword} = req.query;
  const items = await SellItem.find().populate("Owner", "-password -refreshToken");
  if (items.length === 0) {
    throw new ApiError(404, "Sell items not found");
  }
  if (!keyword) {
    return res.status(200).json(new ApiResponse(200, "Sell items retrieved successfully", items));
  }

  const options = {
    keys: ['name', 'description'],
    threshold: 0.3, // Adjust the threshold as needed
  };

  // Initialize Fuse.js with the job postings and options
  const fuse = new Fuse(items, options);

  // Perform the search
  const result = fuse.search(keyword);

  const filteredItems = result.map(({ item }) => item);

  
  res.status(200).json(new ApiResponse(200, "Sell items retrieved successfully", filteredItems));
});

export const getSellItemById = asyncHandler(async (req, res, next) => {
  const { id } = req.query;
  const item = await SellItem.findById(id).populate("Owner", "-password -refreshToken");
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