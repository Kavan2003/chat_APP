import mongoose from "mongoose";

const topicSchema = mongoose.Schema(
  {
    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    duration: {
      type: String,
      required: true
    },
    order: {
      type: Number,
      required: true
    },
    completed: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

topicSchema.index({ title: "text" });

export const Topic = mongoose.model("Topic", topicSchema);