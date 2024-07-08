import { Router } from "express";
import { upload } from "../middlewares/multer.middleware.js";
import {
    uploadBooks,
    deleteBook,
    getAllBooks,
    getOneBook
} from "../controllers/books.controller.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { isPublisher } from "../middlewares/publisher.middleware.js";

const router = Router();


router.route("/upload-book").post(verifyJWT, upload.single("bookPath"), uploadBooks);
router.route("/get-books").get(verifyJWT, getAllBooks);
router.route("/get-book").get(verifyJWT, getOneBook);
router.route("/delete-book/:bookId").delete(verifyJWT, isPublisher, deleteBook)

export default router;