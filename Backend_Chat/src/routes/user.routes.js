import { Router } from "express";
import upload from "../middlewares/multer.middleware.js";
import{registerUser, loginUser, getuserdetailsfromID, changePassword, updateProfile, addAvatar} from "../controllers/user.controller.js";
import { varifyJWT } from "../middlewares/auth.middleware.js";


const userRoute  = Router();



userRoute.route("/register").post(
    upload.fields([
      { name: "avatar", maxCount: 1 },
      { name: "resume", maxCount: 1 },
    ]),
     registerUser);

     userRoute.route("/login").post(upload.none(),loginUser);

userRoute.route("/change-password").post(varifyJWT, upload.none(), changePassword);
userRoute.route("/view-profile").get(varifyJWT, upload.none(), getuserdetailsfromID);


userRoute.route("/update-profile").post(varifyJWT, upload.none(), updateProfile);

userRoute.route("/add-avatar").post(varifyJWT, upload.single("avatar"), addAvatar);


userRoute.route("/").get((req,res)=>{
    res.send("Hello to User API");
});

export default userRoute;