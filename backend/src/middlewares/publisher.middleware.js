import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import {Books} from "../models/books.model.js";


export const isPublisher = asyncHandler( async (req, res, next)=>{
try {
        const bookId = req.params.bookId;
    
        const uploadedBook = await Books.findById(bookId);
    
        const publisher = (uploadedBook.publishedBy === req.user._id)
    
        if(!publisher){
           throw new ApiError(402, "Only publisher can modify the file")
        }
    
        next()
} catch (error) {
    throw new ApiError(401, error?.message || "Access Denied!!!");
}
});