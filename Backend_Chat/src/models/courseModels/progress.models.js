import mongoose from "mongoose";

const learningProgressSchema = mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    completedTopics: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "Topic"
    }],
    completedChapters: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "Chapter"
    }],
    completedQuizzes: [{
      quizId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Quiz"
      },
      score: Number,
      attemptDate: Date
    }],
    completedAssignments: [{
      assignmentId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Assignment"
      },
      grade: Number,
      submissionDate: Date
    }],
    lastAccessedChapter: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Chapter"
    },
    overallProgress: {
      type: Number,
      default: 0
    },
    lastActivity: {
      type: Date,
      default: Date.now
    }
  },
  { timestamps: true }
);

// Compound index for faster lookups
learningProgressSchema.index({ userId: 1, courseId: 1 }, { unique: true });

export const LearningProgress = mongoose.model("LearningProgress", learningProgressSchema);