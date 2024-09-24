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
  .post(varifyJWT, upload.array("images", 10), createSellItem);

sellRoute.route("/id")
  .get(varifyJWT, getSellItemById)
  .put(varifyJWT, upload.array("images", 10), updateSellItem)
  .delete(varifyJWT, asyncHandler(deleteSellItem));

  sellRoute.route("/search")
  .get(varifyJWT,getAllSellItems)

sellRoute.route("/upload")
  .post(varifyJWT, upload.array("images", 10), uploadImages);

export default sellRoute;