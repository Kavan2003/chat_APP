import { Router } from "express";
import { varifyJWT } from "../middlewares/auth.middleware.js";
import { asyncHandler } from "../utils/AsyncHandler.js";
import {createJob, getAllJobs, jobviebyId} from "../controllers/job.controller.js";

const jobRoute = Router();

jobRoute.route("/")
.get((req,res)=>{
  res.send("Hello to Job API");
})
  .post(varifyJWT,createJob);

jobRoute.route("/jobbyid")
  .get(varifyJWT, jobviebyId)
  // .put(varifyJWT, asyncHandler(updateJobPosting))
  // .delete(varifyJWT, asyncHandler(deleteJobPosting));

jobRoute.route("/search")
  .get(varifyJWT, asyncHandler(getAllJobs));


export default jobRoute;
