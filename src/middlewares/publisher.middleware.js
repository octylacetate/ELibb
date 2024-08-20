import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { Books } from "../models/books.model.js";

export const isPublisher = asyncHandler(async (req, res, next) => {
    try {
        const bookId = req.params.bookId;

        const uploadedBook = await Books.findById(bookId);
        if (!uploadedBook) {
            throw new ApiError(404, "Book not found");
        }
        if (uploadedBook.publishedBy.toString() !== req.user._id.toString()) {
            throw new ApiError(403, "Only the publisher can modify the file");
        }
        next();
    } catch (error) {
        throw new ApiError(401, error?.message || "Access Denied");
    }
});
