import { RecentlyViewed } from "../models/recentlyViewed.model.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/asyncHandler.js";

const getRecentlyViewedBooks = asyncHandler(async (req, res) => {
    const userId = req.user._id;

    const recentBooks = await RecentlyViewed.find({ user: userId })
        .populate('book')
        .sort({ updatedAt: -1 })
        .limit(10);

    return res.status(200).json(
        new ApiResponse(200, {
            recentBooks
        }, "Recently viewed books fetched successfully")
    );
});

const addToRecentlyViewed = asyncHandler(async (req, res) => {
    const { bookId } = req.params;
    const userId = req.user._id;

    // Update or create recently viewed entry
    const recentlyViewed = await RecentlyViewed.findOneAndUpdate(
        { user: userId, book: bookId },
        { $set: { user: userId, book: bookId } },
        { upsert: true, new: true }
    );

    return res.status(200).json(
        new ApiResponse(200, {
            recentlyViewed
        }, "Book added to recently viewed")
    );
});

const updateReadingProgress = asyncHandler(async (req, res) => {
    const { bookId } = req.params;
    const { progress } = req.body;
    const userId = req.user._id;

    if (typeof progress !== 'number' || progress < 0 || progress > 1) {
        throw new ApiError(400, "Invalid progress value. Must be between 0 and 1");
    }

    const recentlyViewed = await RecentlyViewed.findOneAndUpdate(
        { user: userId, book: bookId },
        { 
            $set: { 
                progress,
                user: userId,
                book: bookId 
            } 
        },
        { upsert: true, new: true }
    );

    return res.status(200).json(
        new ApiResponse(200, {
            recentlyViewed
        }, "Reading progress updated successfully")
    );
});

export {
    getRecentlyViewedBooks,
    addToRecentlyViewed,
    updateReadingProgress
}; 