import mongoose from "mongoose";

const assignmentSchema = mongoose.Schema(
  {
    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    chapterId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Chapter"
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    dueDate: {
      type: Date
    },
    points: {
      type: Number,
      default: 10
    },
    content: {
      type: String
    },
    attachments: [{
      type: String
    }],
    completed: {
      type: Boolean,
      default: false
    },
    grade: {
      type: Number
    },
    feedback: {
      type: String
    },
    submissionDate: {
      type: Date
    }
  },
  { timestamps: true }
);

export const Assignment = mongoose.model("Assignment", assignmentSchema);