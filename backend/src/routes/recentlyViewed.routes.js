import { Router } from "express";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import {
    getRecentlyViewedBooks,
    addToRecentlyViewed,
    updateReadingProgress
} from "../controllers/recentlyViewed.controller.js";

const router = Router();

// Apply authentication middleware to all routes
router.use(verifyJWT);

// Get recently viewed books
router.route("/get-recently-viewed").get(getRecentlyViewedBooks);

// Add a book to recently viewed
router.route("/add-recently-viewed/:bookId").post(addToRecentlyViewed);

// Update reading progress
router.route("/update-progress/:bookId").patch(updateReadingProgress);

export default router; 