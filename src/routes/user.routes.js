import { Router } from "express";
import upload from "../middlewares/multer.middleware.js";
import{registerUser,loginUser} from "../controllers/user.controller.js";


const userRoute  = Router();

userRoute.route("/register").post(
    upload.fields([
      { name: "avatar", maxCount: 1 },
      { name: "resume", maxCount: 1 },
    ]),
     registerUser);

     userRoute.route("/login").post(upload.none(),loginUser);

export default userRoute;