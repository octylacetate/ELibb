import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js"
import { Books } from "../models/books.model.js";
import { ApiResponse } from "../utils/ApiResponse.js";


const uploadBooks = asyncHandler(async (req, res) => {
    const bookTitle = req.body;
    const bookPath = req.file?.path;

    try {
        if (!bookTitle || !bookPath) {
            throw new ApiError(400, "All fields are required")
        }
        const book = await Books.create({
            bookTitle,
            bookPath
        })

        if(!book){
            throw new ApiError(402, "Something went wrong while uploading the book")
        }

        return res.status(200).json(new ApiResponse(200,
            { book },
            'book uploaded successfully'
        ));
    } catch (error) {
        throw new ApiError(500, "Something went wrong, couldn't upload the book")
    }
}) 

const getAllBooks = asyncHandler(async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = 10;
        const skip = (page - 1) * limit;
        
        const allBooks = await Books.find().skip(skip).limit(limit);

        if(!allBooks){
            throw new ApiError(402, "couldn't get the books");
        }

        const totalDocuments = await Books.countDocuments();
        //Total pages
        const totalPages = Math.ceil(totalDocuments / limit);

        return res.status(200).json(new ApiResponse(200, {
            allBooks,
            page,
            totalPages,
            totalDocuments
        }, 'Books displayed successfully'));
    } catch (error) {
        throw new ApiError(500, "Something went wrong, couldn't get the books");
    }})

    const getOneBook = asyncHandler( async (req, res) => {
        try {
           const bookId = re.param.bookId;
            
            const book = Books.findById(bookId)

            if(!book){
                throw new ApiError(401, "Book doesn't exists")
            }
            return res.status(200).json(
                new ApiResponse(
                    200,
                    { book },
                    "Book deleted Successfully"
                )
            )
        } catch (error) {
            throw new ApiError(401, "Something went wrong, Book doesn't exists")
        }
    })

const deleteBook = asyncHandler(async (req, res) => {
    const bookId = req.params.bookId;
    try {
        const bookDeleted = await Books.findOneAndDelete({ _id: bookId });
        if (!bookDeleted) {
            throw new ApiError(400, "book not deleted")
        }
        return res.status(200).json(
            new ApiResponse(
                200,
                {},
                "Book deleted Successfully"
            )
        )
    } catch (error) {
        throw new ApiError(500, error?.message || "Something went Wrong")
    }

}

)

export {
    uploadBooks,
    getAllBooks,
    getOneBook,
    deleteBook
}