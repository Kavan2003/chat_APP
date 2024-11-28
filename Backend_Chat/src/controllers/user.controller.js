import { asyncHandler } from "../utils/AsyncHandler.js";
import Joi from "joi";
import { User } from "../models/user.models.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { uploadFileOnCloudinary } from "../utils/cloudnary.js";

const generateRefreshTokenAndAccessToken = async (userid) => {
  try {
    const user = await User.findById(userid);
    if (!user) {
      throw new ApiError(404, "User not found while generating tokens");
    }
    const refreshToken = user.generateRefreshToken();
    const accessToken = user.generateAccessToken();

    await user.save({ validateBeforeSave: false });

    return { refreshToken, accessToken };
  } catch (error) {
    console.log("Error in generating tokens ", error);
    throw new ApiError(500, "Error in generating tokens ", error.message);
  }
};

const getuserdetailsfromID = asyncHandler(async (req, res, next) => {
  // const { id } = req.query;
  const id = req.user.id;
  const user = await User.findById(id).select("-password -refreshToken");
  if (!user) {
    throw new ApiError(404, "User not found");
  }
  res.status(200).json(new ApiResponse(200, "User details retrieved", user));
});

const registerUser = asyncHandler(async (req, res, next) => {
  const registerUserSchema = Joi.object({
    username: Joi.string().required().messages({
      "string.empty": "Username is required",
    }),
    email: Joi.string().email().required().messages({
      "string.email": "Email is required",
      "string.empty": "Email is required",
    }),

    password: Joi.string().required().messages({
      "any.required": "password is required",
    }),

    isAdmin: Joi.boolean().messages({
      "any.required": "isAdmin is required",
    }),
    YearOFStudy: Joi.number().required().messages({
      "any.required": "YearOFStudy is required",
    }),
    Branch: Joi.string().required().messages({
      "any.required": "Branch is required",
    }),
    skills: Joi.array().items(Joi.string()).required().messages({
      "any.required": "Skills is required",
    }),
    description: Joi.string().required().messages({
      "any.required": "description is required",
    }),

    resume: Joi.string().messages({
      "string.empty": "resume is required",
    }),
  });

  const {
    username,
    email,
    password,
    isAdmin,
    YearOFStudy,
    Branch,
    skills,
    description,
  } = req.body;

  var resumelocalfile = "";
  if (req.files?.resume) {
    resumelocalfile = req.files.resume[0].path;
  }

  var avatarlocalfile;
  if (req.files?.avatar) {
    // Fixed from req.files?.cover to req.files?.avatar
    avatarlocalfile = req.files.avatar[0]?.path;
  } else {
    avatarlocalfile = "";
  }

  const skillsArray = skills.split(",");

  const { error } = registerUserSchema.validate(
    {
      username,
      email,
      password,
      isAdmin,
      YearOFStudy,
      Branch,
      skills:  skillsArray,
      description,
      resume: resumelocalfile,
    },
    { abortEarly: false }
  );

  if (error) {
    const errorMessage = error.details.map((detail) => detail.message);
    throw new ApiError(400, errorMessage);
  } else {
    console.log("hello resume", resumelocalfile);
    const existingUser = await User.findOne({
      $or: [{ username }, { email }],
    });
    if (existingUser) {
      throw new ApiError(
        400,
        "User already exists with this email or username"
      );
    } else {
      const resumeurl = await uploadFileOnCloudinary(resumelocalfile);
      console.log("resumeurl", resumeurl);
      let avatarurl;
      if (avatarlocalfile !== "") {
        avatarurl = await uploadFileOnCloudinary(avatarlocalfile);
      }

      const newUser = await User.create({
        username: username.toLowerCase(), // Fixed typo in method call
        email,
        password,
        isAdmin,
        YearOFStudy,
        Branch,
        skills,
        description,
        Avatar: avatarurl?.url || "",
        resume: resumeurl?.url || "",
      });
      const Owner = await User.findById(newUser._id).select(
        "-password -refreshToken"
      );
      if (!Owner) {
        throw new ApiError(400, "Error in creating user");
      }
      const { refreshToken, accessToken } =
    await generateRefreshTokenAndAccessToken(newUser._id);

      return res
        .status(201)
        .json(
          new ApiResponse(201, "User registered successfully", {
            Owner,
            accessToken,
            refreshToken,
          })
        );
    }
  }
});

const loginUser = asyncHandler(async (req, res) => {
  //  take data from user req.body
  // validate the data using Email/Username and password
  // if user exists, generate token and send it to user
  // if user does not exist, send error message
  // do refresh token logic
  // send response to user and cookie

  const { email, username, password } = req.body;
  // console.log("email", req.body);
  // if(!email && !username){
  //   throw new ApiError(statusCodes.BAD_REQUEST, "Email or username is required");
  // }
  const Schema = Joi.object({
    email: Joi.string().email().messages({
      "string.email": "Invalid email format",
    }),
    username: Joi.string().messages({
      "string.base": "Invalid username format",
    }),
    password: Joi.string().required().messages({
      "any.required": "Password is required",
    }),
  })
    .or("email", "username")
    .messages({
      "object.missing": "Either Email or username is required",
    });
  const { error } = Schema.validate(
    { email, username, password },
    { abortEarly: false }
  );
  if (error) {
    // console.log("error", error);
    throw new ApiError(
      400,
      error.details.map((detail) => detail.message)
    );
  }
  const user = await User.findOne({ $or: [{ email }, { username }] });
  if (!user) {
    throw new ApiError(404, "User not found");
  }
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new ApiError(401, "Invalid credentials");
  }
  const { refreshToken, accessToken } =
    await generateRefreshTokenAndAccessToken(user._id);

  const Owner = await User.findById(user._id).select("-password -refreshToken");

  const cookieOptions = {
    httpOnly: true,
    secure: true,
  };
  res
    .status(200)
    .cookie("refreshToken", refreshToken, cookieOptions)
    .cookie("accessToken", accessToken, cookieOptions)
    .json(
      new ApiResponse(200, "Success", {
        Owner,
        accessToken,
        refreshToken,
      })
    );
});

const changePassword = asyncHandler(async (req, res, next) => {
  const { oldPassword, newPassword } = req.body;
  const userId = req.user.id;

  const user = await User.findById(userId);
  if (!user) {
    throw new ApiError(404, "User not found");
  }

  const isMatch = await user.comparePassword(oldPassword);
  if (!isMatch) {
    throw new ApiError(401, "Old password is incorrect");
  }

  user.password = newPassword;
  await user.save();

  res.status(200).json(new ApiResponse(200, "Password changed successfully"));
});

const updateProfile = asyncHandler(async (req, res, next) => {
  const { username, email, YearOFStudy, Branch, skills, description } = req.body;
  const userId = req.user.id;

  const user = await User.findById(userId);
  if (!user) {
    throw new ApiError(404, "User not found");
  }

  user.username = username || user.username;
  user.email = email || user.email;
  user.YearOFStudy = YearOFStudy || user.YearOFStudy;
  user.Branch = Branch || user.Branch;
  user.skills = skills ? skills.split(",") : user.skills;
  user.description = description || user.description;

  await user.save();

  res.status(200).json(new ApiResponse(200, "Profile updated successfully", user));
});

const addAvatar = asyncHandler(async (req, res, next) => {
  const userId = req.user.id;

  if (!req.file) {
    throw new ApiError(400, "No file uploaded");
  }

  const avatarUrl = await uploadFileOnCloudinary(req.file.path);

  const user = await User.findById(userId);
  if (!user) {
    throw new ApiError(404, "User not found");
  }

  user.Avatar = avatarUrl.url;
  await user.save();

  res.status(200).json(new ApiResponse(200, "Avatar added successfully", user));
});

export { registerUser, loginUser, getuserdetailsfromID, changePassword, updateProfile, addAvatar };