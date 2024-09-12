import { Router } from "express";
import { listChat, SearchHistorys, searchQuery,getMessages } from "../controllers/chat.controller.js";
import { varifyJWT } from "../middlewares/auth.middleware.js";
import { User } from "../models/user.models.js";

const userRoute  = Router();



userRoute.route("/listchats").get(varifyJWT,listChat);
userRoute.route("/search").get(varifyJWT,searchQuery);
userRoute.route("/searchhistory").get(varifyJWT,SearchHistorys);
userRoute.route("/getmessages").post(varifyJWT,getMessages);

    //  userRoute.route("/login").post(loginUser);

userRoute.route("/").get((req,res)=>{
    res.send("Hello to User API");
});

export default userRoute;