import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js"
import { Favourite } from "../models/favourite.model.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { Books } from "../models/books.model.js";


const addFavourite = asyncHandler( async (req, res) => {
    try {
        const bookId = req.params.bookId;

        if(!bookId){
            throw new ApiError(402, "Couldn't get the book")
        }

        const favouriteBook = await Books.findById(bookId);
        
        const addedToFavourite = await Favourite.create(
            {
                book: bookId,
                user: req.user
            }
        )
        res.status(200).json( new ApiResponse(
                200,
                {addedToFavourite},
                "added to favourite successfully"
        ))
    } catch (error) {
        throw new ApiError(500, "Something went wrong while adding to favourite")
    }
})

const getAllFavourite = asyncHandler( async (req, res) => {
    try {
        const userId = req.user;

        const allFavourites = await Favourite.find({user: userId});
        res.status(200).json( new ApiResponse(
                200,
                { allFavourites },
                "Favourites displayed successfully"
        ))
    } catch (error) {
        throw new ApiError(500, "Something went wrong while getting the favourites")
    }
})


const removeFavourite = asyncHandler(async (req, res) => {
    try {
        const bookId = req.params.bookId;
        const favourite = await Favourite.findOne({ book: bookId, user: req.user });

        if (!favourite) {
            throw new ApiError(404, "Favorite not found");
        }

        const deletedFavourite = await Favourite.findOneAndDelete({ _id: favourite._id });

        res.status(200).json(new ApiResponse(
            200,
            {},
            "Removed from favorites successfully"
        ));
    } catch (error) {
        throw new ApiError(500, "Something went wrong while removing the favorite");
    }
});


export {
    addFavourite,
    getAllFavourite,
    removeFavourite
}