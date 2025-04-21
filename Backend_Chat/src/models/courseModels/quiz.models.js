import mongoose from "mongoose";

const quizQuestionSchema = mongoose.Schema({
  question: {
    type: String,
    required: true
  },
  options: [{
    type: String,
    required: true
  }],
  correctAnswer: {
    type: Number,
    required: true
  },
});

const quizSchema = mongoose.Schema(
  {
    chapterId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Chapter",
      required: true
    },
    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    title: {
      type: String,
      required: true
    },
    questions: [quizQuestionSchema],
    score: {
      type: Number,
      default: 0
    },
    completed: {
      type: Boolean,
      default: false
    },
    attempts: {
      type: Number,
      default: 0
    }
  },
  { timestamps: true }
);

export const Quiz = mongoose.model("Quiz", quizSchema);