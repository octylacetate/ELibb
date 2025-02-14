import { fileURLToPath } from 'url';
import path from 'path';
import fs from 'fs';
import { asyncHandler } from '../utils/asyncHandler.js';
import { ApiError } from '../utils/ApiError.js';
import { Books } from '../models/books.model.js';
import { ApiResponse } from '../utils/ApiResponse.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const uploadBooks = asyncHandler(async (req, res) => {
    const { bookTitle, author, description, genre } = req.body;
    const bookPath = req.files?.bookPath[0].path.split('public\\').pop().replace(/\\/g, '/'); 
    const bookCoverPath = req.files?.bookCover[0].path.split('public\\').pop().replace(/\\/g, '/'); 

    if (!bookTitle || !bookPath || !bookCoverPath || !genre) {
        throw new ApiError(400, "All fields are required");
    }

    const book = await Books.create({
        bookTitle,
        author,
        description,
        genre,
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
        
        // Add genre filter
        const genre = req.query.genre;
        const query = genre && genre !== 'All genres' ? { genre } : {};
        
        const allBooks = await Books.find(query).skip(skip).limit(limit);

        if (!allBooks || allBooks.length === 0) {
            throw new ApiError(404, "No books found");
        }

        const totalDocuments = await Books.countDocuments(query);
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
    }
});

const getOneBook = asyncHandler(async (req, res) => {
    try {
      const bookId = req.params.bookId;  // Corrected here
  
      const book = await Books.findOne({ _id: bookId });
  
      if (!book) {
        throw new ApiError(404, "Book doesn't exist");  // Changed to 404
      }
      return res.status(200).json(
        new ApiResponse(
          200,
          { book },
          "Book fetched successfully"
        )
      );
    } catch (error) {
      throw new ApiError(500, "Something went wrong, couldn't get the book");  // Changed to 500
    }
});

const deleteBook = asyncHandler(async (req, res) => {
  
        const bookId = req.params.bookId;
      
        try {
          // Find the department to get the thumbnail path
          const bookToDelete = await Books.findOne({ _id: bookId });
      
          if (!bookToDelete) {
            throw new ApiError(400, "Book not available");              }
      
          // Remove the department from the database
          await Books.findOneAndDelete({ _id: bookId });
      
          // Delete the thumbnail image from the public folder
          const bookPath = path.join('public', bookToDelete.bookPath.replace('/public/', ''));
          
          if (fs.existsSync(bookPath)) {
            fs.unlinkSync(bookPath);
          }
      

      return res.status(200).json(new ApiResponse(200, {}, "Book deleted successfully"));
    } catch (error) {
      return res.status(500).json(new ApiResponse(500, {}, error.message || "Something went wrong"));
    }
});

const publishedBooks = asyncHandler( async (req, res) => {
  try {

      const userId = req.user._id.toString();
      const publisherBooks = await Books.find({publishedBy: userId});

      if (!publisherBooks || publisherBooks.length === 0) {
        throw new ApiError(404, "User doesn't have any published books");
    }
      
      return res.status(200).json(new ApiResponse(
          200, 
          { publisherBooks }, 
          "Book retrieved successfully"
      ));

  } catch (error) {
      return res.status(500).json(new ApiError(
          500, 
          error.message || "Something went wrong"
      ));
  }
});

const getGenreCounts = asyncHandler(async (req, res) => {
    try {
        const genreCounts = await Books.aggregate([
            {
                $group: {
                    _id: '$genre',
                    count: { $sum: 1 }
                }
            }
        ]);

        const counts = {};
        genreCounts.forEach(item => {
            counts[item._id] = item.count;
        });

        const allGenres = [
            'Fantasy', 'Sci-fi', 'Mystery', 'Romance', 'Historical-fi',
            'Thriller', 'Non-fiction', 'Young-adult', "Children's-literature"
        ];
        
        allGenres.forEach(genre => {
            if (!counts[genre]) {
                counts[genre] = 0;
            }
        });

        return res.status(200).json(
            new ApiResponse(200, counts, 'Genre counts retrieved successfully')
        );
    } catch (error) {
        throw new ApiError(500, "Error retrieving genre counts");
    }
});

export {
    uploadBooks,
    getAllBooks,
    getOneBook,
    deleteBook,
    publishedBooks,
    getGenreCounts
}