import mongoose from "mongoose";

const favouriteSchema = mongoose.Schema({
    book:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Books"
    },

    user:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    }
},{timestamps: true})

const Favourite = mongoose.model("Favourite", favouriteSchema)
export { Favourite }