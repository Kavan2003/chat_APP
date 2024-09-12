import { asyncHandler } from "../utils/AsyncHandler.js";
import { ChatRequests } from "../models/chatRequest.models.js";
import { User } from "../models/user.models.js";
import { ApiError } from "../utils/ApiError.js";
import Fuse from "fuse.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { SearchHistory } from "../models/searchHistory.models.js";
import { Chat } from "../models/chat.models.js";

const listChat = asyncHandler(async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json(new ApiError(401, "Unauthorized"));
    }
    const userId = req.user.id;

    // Fetch chat requests where the status is "accepted"

    const acceptedRequests = await ChatRequests.find({
      status: "accepted",
      $or: [{ recipient: userId }, { requester: userId }],
    });

    // Extract user IDs from both the recipient and requester fields of the chat requests
    const userIds = acceptedRequests.reduce((ids, request) => {
      ids.add(request.recipient.toString());
      ids.add(request.requester.toString());
      return ids;
    }, new Set());
    userIds.delete(userId.toString());
    // Fetch user details (user ID, avatar, username) for each user ID
    const users = await User.find({ _id: { $in: Array.from(userIds) } }).select(
      "username Avatar"
    );
    const formattedUsers = users.map(user => ({
      id: user._id,
      username: user.username,
      avatar: user.Avatar,
    }));

    // Send the response with the list of users
    res.json(new ApiResponse(200, "List of available users", formattedUsers));
  } catch (error) {
    console.error("Failed to fetch chat requests", error);
    res.status(500).json(ApiError(500, "Failed to fetch chat requests", error));
  }
});

const searchQuery = asyncHandler(async (req, res, next) => {
  try {
    const { query } = req.query;

    if (!query) {
      return res.status(400).json({ message: "Query parameter is required" });
    }

    // Fetch all users
    const users = await User.find().select(
      "username skills description Branch"
    );

    // Set up Fuse.js options
    const options = {
      keys: ["username", "skills", "description", "Branch"],
      threshold: 0.3, // Adjust the threshold for more or less fuzzy matching
    };

    // Create a Fuse instance
    const fuse = new Fuse(users, options);

    // Perform the search
    const results = fuse.search(query);

    // Extract the matched items
    const matchedUsers = results.map((result) => result.item);

    const matchedUserIds = matchedUsers.map((user) => user._id);

    // Check if the search history already exists for the user and query
    let searchHistory = await SearchHistory.findOne({
      Owner: req.user.id,
      search: query,
    });

    if (searchHistory) {
      // Update the existing search history
      searchHistory.resultIds = matchedUserIds;
      await searchHistory.save();
    } else {
      // Create a new search history
      searchHistory = new SearchHistory({
        Owner: req.user.id,
        search: query,
        resultIds: matchedUserIds,
      });
      await searchHistory.save();
    } 
    res.json(new ApiResponse(200, "Search results", matchedUsers));
  } catch (error) {
    console.error("Failed to perform search", error);
    res.status(500).json(new ApiError(500, "Failed to perform search", error));
  }
});

const SearchHistorys = asyncHandler(async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json(new ApiError(401, "Unauthorized"));
    }

    const userId = req.user.id;

    // Fetch all search history specific to the user
    const recentSearches = await SearchHistory.find({ Owner: userId })
      .sort({ createdAt: -1 })
      .select("search createdAt");

    // Fetch all search histories to determine trending searches
    const allSearchHistories = await SearchHistory.find().select("search");

    // Aggregate search terms and their counts
    const searchCounts = allSearchHistories.reduce((counts, history) => {
      const searchTerm = history.search.toLowerCase();
      counts[searchTerm] = (counts[searchTerm] || 0) + 1;
      return counts;
    }, {});

    // Convert searchCounts to an array of { term, count } objects
    const searchCountArray = Object.keys(searchCounts).map((term) => ({
      term,
      count: searchCounts[term],
    }));

    // Set up Fuse.js options for fuzzy search
    const options = {
      keys: ["term"],
      threshold: 0.3, // Adjust the threshold for more or less fuzzy matching
    };

    // Create a Fuse instance
    const fuse = new Fuse(searchCountArray, options);

    // Group similar search terms using fuzzy search
    const groupedSearchCounts = searchCountArray.reduce((groups, item) => {
      const result = fuse.search(item.term);
      const groupKey = result.length > 0 ? result[0].item.term : item.term;
      if (!groups[groupKey]) {
        groups[groupKey] = { term: groupKey, count: 0 };
      }
      groups[groupKey].count += item.count;
      return groups;
    }, {});

    // Convert groupedSearchCounts to an array and sort by count in descending order
    const trendingSearches = Object.values(groupedSearchCounts)
      .sort((a, b) => b.count - a.count)
      .slice(0, 5); // Get top 5 trending searches

    // Send the response with trending and recent searches
    res.json(
      new ApiResponse(200, "Search history", {
        trending: trendingSearches,
        recents: recentSearches,
      })
    );
  } catch (error) {
    console.error("Failed to fetch search history", error);
    res.status(500).json(new ApiError(500, "Failed to fetch search history", error));
  }
});


const getMessages = asyncHandler(async (req, res, next) => {

const { ownerId, SrnderId,grpId } = req.body;
try{
if((ownerId & SrnderId) || grpId){
return res.status(400).json(new ApiError(400, "Send either ownerId and SrnderId or grpId"));
}
let messages;
if(ownerId && SrnderId){
messages = await Chat.find({
$or: [
{ sender: ownerId, recipient: SrnderId },
{ sender: SrnderId, recipient: ownerId },
],
});

}
else{
messages = await Chat.find({ groupId: grpId });
}
res.json(new ApiResponse(200, "Messages fetched successfully", messages));
}
catch(error){
console.error("Failed to fetch messages", error);
res.status(500).json(new ApiError(500, "Failed to fetch messages", error));
}

});

export { listChat,SearchHistorys, searchQuery,getMessages };
