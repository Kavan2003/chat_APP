import { Router } from "express";
import { varifyJWT } from "../middlewares/auth.middleware.js";
import { asyncHandler } from "../utils/AsyncHandler.js";
import {
  createJobPosting,
  getAllJobPostings,
  getJobPostingById,
  updateJobPosting,
  deleteJobPosting,
} from "../controllers/job.controller.js";

const jobRoute = Router();

jobRoute.route("/")
  .get(varifyJWT, asyncHandler(getAllJobPostings))
  .post(varifyJWT, asyncHandler(createJobPosting));

jobRoute.route("/:id")
  .get(varifyJWT, asyncHandler(getJobPostingById))
  .put(varifyJWT, asyncHandler(updateJobPosting))
  .delete(varifyJWT, asyncHandler(deleteJobPosting));

export default jobRoute;
