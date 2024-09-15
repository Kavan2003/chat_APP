import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';
import cookieParser from 'cookie-parser';
const app = express();
app.use(bodyParser.json({ limit: '30mb', extended: true }));
app.use(bodyParser.urlencoded({ limit: '30mb', extended: true }));
app.use(cors());
app.use(cookieParser());


//routes 

//user route
import userRoute from '../src/routes/user.routes.js';

app.use('/api/user',userRoute);

//chat route
import chatRoute from '../src/routes/chat.routes.js';
import sellRoute from './routes/sell.routes.js';
import jobRoute from './routes/job.routes.js';
app.use('/api/chat',chatRoute);
app.use('/api/sell',sellRoute);
app.use('/api/job',jobRoute);



export default app;
