import { Router } from "express";
import {
    addFavourite,
    removeFavourite,
    getAllFavourite
} from "../controllers/favourite.controllers.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";

const router = Router();


router.route("/add-favourite/:bookId").post(verifyJWT, addFavourite);
router.route("/remove-favourite/:bookId").delete(verifyJWT, removeFavourite);
router.route("/get-favourites").get(verifyJWT, getAllFavourite);

export default router;