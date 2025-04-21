import mongoose from "mongoose";

const referenceSchema = mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  url: {
    type: String
  },
  description: {
    type: String
  }
});

const chapterSchema = mongoose.Schema(
  {
    topicId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Topic",
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
    content: {
      type: String,
      required: true
    }, // Markdown content
    references: [referenceSchema],
    completed: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

chapterSchema.index({ title: "text", content: "text" });

export const Chapter = mongoose.model("Chapter", chapterSchema);