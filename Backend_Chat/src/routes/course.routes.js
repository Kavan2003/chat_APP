import express from 'express';
import { varifyJWT } from "../middlewares/auth.middleware.js";
import upload from "../middlewares/multer.middleware.js";
import { createCourseandTopic } from '../controllers/courseController/CourseandTopic.controller.js';

const router = express.Router();

// Course routes
router.route("/create")
    .post(varifyJWT, createCourseandTopic);

// router.route("/my-courses")
//     .get(varifyJWT, getUserCourses);

// router.route("/:courseId")
//     .get(varifyJWT, getCourseById)
//     .put(varifyJWT, updateCourse)
//     .delete(varifyJWT, deleteCourse);

// // Topic routes
// router.route("/:courseId/topics")
//     .get(varifyJWT, getTopicsByCourse);

// router.route("/:courseId/topics/:topicId")
//     .get(varifyJWT, getTopicById)
//     .put(varifyJWT, updateTopic)
//     .delete(varifyJWT, deleteTopic);

// router.route("/:courseId/topics/:topicId/complete")
//     .post(varifyJWT, markTopicComplete);

// // Chapter routes
// router.route("/:courseId/topics/:topicId/chapters")
//     .post(varifyJWT, createChapter)
//     .get(varifyJWT, getChaptersByTopic);

// router.route("/:courseId/chapters/:chapterId")
//     .get(varifyJWT, getChapterById)
//     .put(varifyJWT, updateChapter)
//     .delete(varifyJWT, deleteChapter);

// router.route("/:courseId/chapters/:chapterId/complete")
//     .post(varifyJWT, markChapterComplete);

// // Quiz routes
// router.route("/:courseId/chapters/:chapterId/quiz")
//     .post(varifyJWT, createQuiz)
//     .get(varifyJWT, getQuizByChapter);

// router.route("/:courseId/quiz/:quizId")
//     .get(varifyJWT, getQuizById)
//     .put(varifyJWT, updateQuiz);

// router.route("/:courseId/quiz/:quizId/submit")
//     .post(varifyJWT, submitQuizAnswers);

// router.route("/:courseId/quiz/:quizId/results")
//     .get(varifyJWT, getQuizResults);

// // Assignment routes
// router.route("/:courseId/assignments")
//     .post(varifyJWT,createAssignment)
//     .get(varifyJWT, getCourseAssignments);

// router.route("/:courseId/assignments/:assignmentId")
//     .get(varifyJWT, getAssignmentById)
//     .put(varifyJWT, updateAssignment)
//     .delete(varifyJWT, deleteAssignment);

// router.route("/:courseId/assignments/:assignmentId/submit")
//     .post(varifyJWT, upload.single("attachments"), submitAssignment);

// // Progress routes
// router.route("/:courseId/progress")
//     .get(varifyJWT, getCourseProgress);

// router.route("/:courseId/progress/update")
//     .put(varifyJWT, updateCourseProgress);

// router.route("/:courseId/progress/stats")
//     .get(varifyJWT, getCourseProgressStats);

// // Search and filtering
// router.route("/search")
//     .get(varifyJWT, searchCourses);

// // Course generation
// router.route("/generate")
//     .post(varifyJWT, generateCourse);

export default router;