import mongoose from "mongoose";

const JobPostingSchema = mongoose.Schema(
  {
    Owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Owner is required"],
    },
    skills: {
      type: [String], // Array of skills required for the job
      required: [true, "Skills are required"],
    },
    jobDescription: {
      type: String,
      required: [true, "Job Description is required"],
    },
    companyWebsite: {
      type: String,
      required: [true, "Company Website is required"],
    },
  },
  { timestamps: true }
);

export const JobPosting = mongoose.model("JobPosting", JobPostingSchema);