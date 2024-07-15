import { v2 as cloudinary } from "cloudinary";
import fs from "fs";
import dotenv from "dotenv";

dotenv.config();
cloudinary.config(
  {
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
  },
);

const uploadFileOnCloudinary = async (localFliePath) => {
  try {
    if (!localFliePath) {
      throw new Error("File path is required");
    }
   
    else {
      let resourceType = 'auto'; // Default to auto to handle various file types
      if (localFliePath.endsWith('.pdf')) {
        resourceType = 'raw'; // Set to 'raw' for non-image files like PDF
      }
      
      const response = await cloudinary.uploader.upload(localFliePath, {
        resource_type: resourceType,
      });
      console.log("File is Upload on Cloudinary url=",response.url);
      fs.unlink(localFliePath, (err) => {
        if (err) {
          console.error("Error deleting file:", err);
          // Handle the error according to your application's needs
        } else {
          console.log("File deleted successfully");
        }
      });
            return response;
    }
  } catch (error) {
    console.error("Error in uploadFileOnCloudinary", error);

    fs.unlinkSync(localFliePath); //delete file from local storage
    return null;
  }
};

export { uploadFileOnCloudinary };
