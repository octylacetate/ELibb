import { Router } from "express";
import { upload } from "../middlewares/multer.middleware.js";
import {
    uploadBooks,
    deleteBook,
    getAllBooks,
    getOneBook,
    publishedBooks,
    getBooksByCategory,
    searchBooks
} from "../controllers/books.controller.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { isPublisher } from "../middlewares/publisher.middleware.js";

const router = Router();


router.route("/upload-book").post(verifyJWT, upload.fields([
    { name: 'bookPath', maxCount: 1 },
    { name: 'bookCover', maxCount: 1 }
]), uploadBooks);
router.route("/get-books").get(verifyJWT, getAllBooks);
router.route("/get-book/:bookId").get(verifyJWT, getOneBook);
router.route("/delete-book/:bookId").delete(verifyJWT, isPublisher, deleteBook)
router.route("/published-books").get(verifyJWT, publishedBooks);
router.route("/get-books-by-category").get(verifyJWT, getBooksByCategory);
router.route("/search-books").get(verifyJWT, searchBooks);

export default router;