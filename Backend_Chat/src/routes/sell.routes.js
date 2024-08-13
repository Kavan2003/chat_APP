import { Router } from "express";
import upload from "../middlewares/multer.middleware.js";
import { varifyJWT } from "../middlewares/auth.middleware.js";
import { asyncHandler } from "../utils/AsyncHandler.js";
import {
  createSellItem,
  getAllSellItems,
  getSellItemById,
  updateSellItem,
  deleteSellItem,
  uploadImages,
} from "../controllers/sell.controller.js";

const sellRoute = Router();

sellRoute.route("/")
  .get(varifyJWT, asyncHandler(getAllSellItems))
  .post(varifyJWT, upload.array("images", 10), asyncHandler(createSellItem));

sellRoute.route("/:id")
  .get(varifyJWT, asyncHandler(getSellItemById))
  .put(varifyJWT, upload.array("images", 10), asyncHandler(updateSellItem))
  .delete(varifyJWT, asyncHandler(deleteSellItem));

sellRoute.route("/upload")
  .post(varifyJWT, upload.array("images", 10), asyncHandler(uploadImages));

export default sellRoute;