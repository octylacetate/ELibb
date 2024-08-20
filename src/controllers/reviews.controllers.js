import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js"
import { Review } from "../models/reviews.model.js";
import { ApiResponse } from "../utils/ApiResponse.js";

const getAllReviews = asyncHandler( async (req, res) => {
    const bookId = req.params;
    try {
        const allReviews = await Review.find({book: bookId})

        if(!allReviews){
            throw new ApiError(404, "Page not available")
        }
        return res.status(200).json(new ApiResponse(
         200,
         { allReviews },
         "Successfully"
        ))
    } catch (error) {
        throw new ApiError(500, "internal server error")
    }
})

const addReview = asyncHandler( async (req, res) => {
    const reviewMessage = req.body;
    const bookId = req.params; 
    try {
        if(!reviewMessage || reviewMessage == ""){
            throw new ApiError(401, "Can't Upload an empty message")
        }
        
        const review = await Review.create(
            {
                message: reviewMessage,
                book: bookId,
                user: req.user
            }
        )
       return res.status(200).json(new ApiResponse(
        200,
        {},
        "Successfully"
       ))
    } catch (error) {
        throw new ApiError(500, "internal server error")
    }
})

const deleteReview = asyncHandler( async (req, res) => {
    try {
        const bookId = req.params;
        if(Review.user.toString() !== req.user.toString()){
            throw new ApiError(401, "you are not authosized to delete the review")
        }

        const deletedReview = await Review.findOneAndDelete({book: bookId, user: req.user})
        return res.status(200).json(new ApiResponse(
         200,
         {},
         "Successfully"
        ))
    } catch (error) {
        throw new ApiError(500, "internal server error")
    }
})

export {
    addReview,
    deleteReview,
    getAllReviews
}