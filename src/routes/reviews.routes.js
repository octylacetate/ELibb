import { Router } from "express";
import {
    addReview,
    deleteReview,
    getAllReviews
} from "../controllers/reviews.controllers.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";

const router = Router();


router.route("/add-review/:bookId").post(verifyJWT, addReview);
router.route("/remove-review/:bookId").delete(verifyJWT, deleteReview);
router.route("/get-reviews/:bookId").get(verifyJWT, getAllReviews);

export default router;