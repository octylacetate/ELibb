import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js"
import { Books } from "../models/books.model.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import fs from 'fs';
import path from 'path'; 


const uploadBooks = asyncHandler(async (req, res) => {
    const { bookTitle, author, description } = req.body;
    const bookPath = req.files?.bookPath[0].path.split('public\\').pop().replace(/\\/g, '/'); 
    const bookCoverPath = req.files?.bookCover[0].path.split('public\\').pop().replace(/\\/g, '/'); 

    if (!bookTitle || !bookPath || !bookCoverPath) {
        throw new ApiError(400, "All fields are required");
    }

    const book = await Books.create({
        bookTitle,
        author,
        description,
        bookPath,
        bookCover: bookCoverPath,
        publishedBy: req.user._id
    });

    if (!book) {
        throw new ApiError(402, "Something went wrong while uploading the book");
    }

    return res.status(200).json(new ApiResponse(200, { book }, 'Book uploaded successfully'));
});

const getAllBooks = asyncHandler(async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = 10;
        const skip = (page - 1) * limit;
        
        const allBooks = await Books.find().skip(skip).limit(limit);

        if (!allBooks || allBooks.length === 0) {
            throw new ApiError(404, "No books found");
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
            
            const book = await Books.findById(bookId)

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
                throw new ApiError(400, "Book not deleted");
            }
    
            const filePath = bookDeleted.bookPath; 
            if (filePath) {
                fs.unlinkSync(filePath); 
            }
    
            return res.status(200).json(
                new ApiResponse(
                    200,
                    {},
                    "Book deleted successfully"
                )
            );
        } catch (error) {
            throw new ApiError(500, error?.message || "Something went wrong");
        }
    });
    

export {
    uploadBooks,
    getAllBooks,
    getOneBook,
    deleteBook
}