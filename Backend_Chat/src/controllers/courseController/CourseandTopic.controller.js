import axios from 'axios';
import { GoogleGenAI } from "@google/genai";
import { asyncHandler } from '../../utils/AsyncHandler.js';
import { ApiError } from '../../utils/ApiError.js';



const createCourseandTopic = asyncHandler(async (req, res, next) => {
  const { courseName, courseDescription } = req.body;
  const owner = req.user._id;
  const resume = req.user.resume == null ? "" : req.user.resume;

  if (!courseName || !courseDescription) {
    throw new ApiError(400, "Course Name and Course Description are required");
  }
  if (!owner) {
    throw new ApiError(401, "Unauthorized");
  }

  const prompt = `Create a course on ${courseName} with the following description: ${courseDescription}. The course should be designed for ${text}.
    Your Task is to First make Difficult Level based on the resume and then make the course with topics and chapters.     
for output the Duration of each  should be in Minutes. 
I want output in JSON format only. and english language. 
follow this exact format given in Sample Output.
      {
  "title": "Mastering Flutter Animations: From Basics to Advanced Techniques",
  "description": "Kavan, based on your experience with Flutter at Sophy e-Technologies and Payvoy India, along with your projects like CourseHelp and the Chat Application, this course is designed to elevate your animation skills. You've already demonstrated a strong foundation, so we'll focus on advanced concepts and practical applications. This will help you build even more engaging and performant user interfaces. \n\n**Here's what you'll gain:**\n*   **Deep Dive:** Uncover advanced animation techniques beyond basic transitions.\n*   **Performance:** Optimize your animations for smooth performance on various devices.\n*   **Real-World Applications:** Learn to implement complex animations in practical scenarios.\n*   **Customization:** Create unique and reusable animation components.",
  "difficulty": "Advanced",
  "estimatedHours": 15,
  "tags": ["Flutter", "Animations", "UI/UX", "Mobile Development", "Dart"],
  "progress": 0,
  "topics": [
    {
      "title": "Introduction to Advanced Flutter Animations",
      "description": "Briefly recap basic Flutter animations and introduce the course's focus on complex and performant animations.",
      "duration": "30 minutes",
      "order": 1,
      "completed": false
    },
    {
      "title": "Implicit Animations: Going Beyond the Basics",
      "description": "Explore advanced uses of ImplicitlyAnimatedWidget, including custom implicit animations and performance considerations.",
      "duration": "90 minutes",
      "order": 2,
      "completed": false
    },
    {
      "title": "AnimatedBuilder and AnimatedWidget: Deep Dive",
      "description": "Understand the power and flexibility of AnimatedBuilder and AnimatedWidget for creating complex and reusable animations.",
      "duration": "120 minutes",
      "order": 3,
      "completed": false
    },
    {
      "title": "Custom Tween Animations: Creating Unique Effects",
      "description": "Learn to create custom Tweens and TweenSequences for highly customized and expressive animations.",
      "duration": "150 minutes",
      "order": 4,
      "completed": false
    },
    {
      "title": "Hero Animations: Advanced Transitions",
      "description": "Explore advanced Hero animation techniques, including shared axis transitions and container transform animations.",
      "duration": "90 minutes",
      "order": 5,
      "completed": false
    },
    {
      "title": "AnimationController: Mastering Control and Orchestration",
      "description": "Dive deep into AnimationController, learning about custom curves, animation status listeners, and complex animation sequencing.",
      "duration": "120 minutes",
      "order": 6,
      "completed": false
    },
    {
      "title": "Performance Optimization: Making Animations Smooth",
      "description": "Learn techniques for optimizing Flutter animations, including using RepaintBoundary, caching widgets, and avoiding unnecessary rebuilds.",
      "duration": "90 minutes",
      "order": 7,
      "completed": false
    },
    {
      "title": "Practical Examples: Real-World Animation Applications",
      "description": "Build several practical examples of complex animations, such as animated lists, parallax effects, and interactive transitions.",
      "duration": "300 minutes",
      "order": 8,
      "completed": false
    },
    {
      "title": "Testing and Debugging Animations",
      "description": "Learn how to effectively test and debug Flutter animations to ensure smooth and reliable performance.",
      "duration": "60 minutes",
      "order": 9,
      "completed": false
    },
    {
      "title": "Integrating Animations with State Management",
      "description": "Explore best practices for integrating Flutter animations with popular state management solutions like Provider and BLoC.",
      "duration": "90 minutes",
      "order": 10,
      "completed": false
    }
  ]
}

    `;

  const ai = new GoogleGenAI({ apiKey: process.env.GOOGLE_API_KEY });
  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: prompt,
  });
  const responseData = response[0].text;
  console.log(responseData);
  const jsonResponse = JSON.parse(responseData);
  console.log(jsonResponse);



})

export { createCourseandTopic };
