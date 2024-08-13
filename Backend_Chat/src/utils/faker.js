
import dotenv from 'dotenv';
dotenv.config();
import { User } from './models/user.models.js'; // Import User model
import { ChatRequests } from './models/chatRequest.models.js'; // Import ChatRequest model
import faker from 'faker'; // Import faker for generating fake data
import bcrypt from "bcrypt";


const populateFakeData = async () => {
    try {
      // Create fake users
      const users = [];
      for (let i = 0; i < 100; i++) {
        const hashedPassword = await bcrypt.hash('password123', 12);
        const user = new User({
          username: faker.internet.userName(),
          email: faker.internet.email(),
          password: hashedPassword, // Use a default password
          YearOFStudy: faker.datatype.number({ min: 1, max: 4 }),
          Branch: faker.commerce.department(),
          skills: [faker.hacker.verb(), faker.hacker.noun()],
          Avatar: faker.image.avatar(),
          description: faker.lorem.sentence(),
          resume: faker.internet.url(),
        });
        users.push(user);
      }
      console.log(users);
      await User.insertMany(users);
  
      // Create fake chat requests
      const chatRequests = [];
      for (let i = 0; i < 100; i++) {
        const chatRequest = new ChatRequests({
          requester: users[faker.datatype.number({ min: 0, max: 9 })]._id,
          recipient: users[faker.datatype.number({ min: 0, max: 9 })]._id,
          status: faker.random.arrayElement(['pending', 'accepted', 'declined']),
        });
        chatRequests.push(chatRequest);
      }
      await ChatRequests.insertMany(chatRequests);
  
      console.log('Fake data populated successfully');
    } catch (error) {
      console.error('Error populating fake data', error);
    }
  };
  
  export { populateFakeData };