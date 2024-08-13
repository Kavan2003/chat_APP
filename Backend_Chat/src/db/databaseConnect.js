import mongoose from "mongoose";
import { DB_NAME } from "../utils/Constant.js";

const connectDB = async () => {
try{
console.log(process.env.MONGODB_URI+"/"+DB_NAME+"Database Connecting");
    const connectionInstance = await mongoose.connect(`${process.env.MONGODB_URI}/${DB_NAME}`)
console.info("Database Connected",connectionInstance.connection.host);
}
catch (error) {
    console.error("Database Connect error :",error.message);
}

}
export default connectDB;