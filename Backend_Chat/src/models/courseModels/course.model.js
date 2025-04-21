import mongoose from "mongoose";

const courseSchema = mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Course title is required"],
      trim: true,
    },
    description: {
      type: String,
      required: [true, "Course description is required"],
    },
    creator: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    difficulty: {
      type: String,
      enum: ["Beginner", "Intermediate", "Advanced"],
      default: "Beginner"
    },
    estimatedHours: {
      type: Number,
    },
  
    tags: [{
      type: String
    }],
    progress: {
      type: Number,
      default: 0
    },
    startDate: {
      type: Date,
      default: Date.now
    },
    completionDate: {
      type: Date
    }
  },
  { timestamps: true }
);

courseSchema.index({ 
  title: "text", 
  description: "text", 
  tags: "text" 
});

export const Course = mongoose.model("Course", courseSchema);