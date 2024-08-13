// index.js
import { createServer } from 'http';
import { Server } from 'socket.io';
import dotenv from 'dotenv';
dotenv.config();
import app from './app.js';
import connectDB from './db/databaseConnect.js';
import { socketHandler } from './socketHandler.js'; // Import the socket handler



const PORT = process.env.PORT || 5000;
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*", // Adjust according to your needs
  },
});


connectDB().then(() => {
  socketHandler(io);
  httpServer.listen(PORT, async () => {
    console.log(`Server is running on port ${PORT}`);
    // await populateFakeData(); // Populate fake data
    // process.exit(); // Exit the process after populating data
  });
}).catch((error) => {
  console.error("Error in connecting to database", error);
});