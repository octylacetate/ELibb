import mongoose from "mongoose";

const reviewSchema = mongoose.Schema({

    message:{
        type: String,
        required: true
    },

    book:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Books"
    },

    user:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    reviewCount:{
        type: Number,
        default: 0
    }
},{timestamps: true})

const Review = mongoose.model("Review", reviewSchema)
export { Review }