import Fuse from "fuse.js";
import { JobPosting } from "../models/job.models.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/AsyncHandler.js";

 const jobviebyId = asyncHandler(async(req,res,next)=>{
    const {id} = req.query;
    if(!id){
        throw new ApiError(400,"Job Id is required");

    }
    const job = await JobPosting.findById(id).populate('Owner');
    if(!job){
        throw new ApiError(404,"Job not found");
    }
    res.status(200).json(new ApiResponse(200,"Job retrieved successfully",job));
});
const createJob = asyncHandler(async(req,res)=>{
const {skills, jobDescription, companyWebsite} = req.body;
const owner = req.user._id;
// console.log(req.body);

if(!skills || !jobDescription || !companyWebsite){
     console.log(skills,jobDescription,companyWebsite);
throw new ApiError(400,"skills, Job Description and Company Website are required");
}
if(!owner){
    // res.status(401).json(new ApiError(401,"Unauthorized"));
throw new ApiError(401,"Unauthorized");
}

const newJob = new JobPosting({
    Owner: owner,
    skills,
    jobDescription,
    companyWebsite,});
    await newJob.save();
res.status(201).json(new ApiResponse(201,"Job created successfully",null));
});


// Get All Jobs with Fuzzy Search
 const getAllJobs = asyncHandler(async (req, res, next) => {
    const { keyword } = req.query;
  
    // Fetch all job postings
    const jobs = await JobPosting.find().populate('Owner');
    // console.log(jobs);
    if(jobs.length === 0){
throw new ApiError(404,"Jobs not found");
    }

  
    if (keyword) {
      // Set up Fuse.js options
      const options = {
        keys: ['skills', 'jobDescription'],
        threshold: 0.3, // Adjust the threshold as needed
      };
  
      // Initialize Fuse.js with the job postings and options
      const fuse = new Fuse(jobs, options);
  
      // Perform the search
      const result = fuse.search(keyword);
  
      // Extract the job postings from the search results
      const filteredJobs = result.map(({ item }) => item);
  
      return res.status(200).json(new ApiResponse(200, "Jobs retrieved successfully", filteredJobs));
    }
  
    res.status(200).json(new ApiResponse(200, "Jobs retrieved successfully", jobs));
  });
  
    export { createJob, getAllJobs, jobviebyId };