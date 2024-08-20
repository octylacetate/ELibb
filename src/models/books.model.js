import mongoose from "mongoose";

const bookSchema = mongoose.Schema({
    bookTitle:{
        type: String,
        required: true
    },
    
    bookPath:{
        type: String,
        required: true
    },

    bookCover: {
        type: String,
        required: true
    },

    author: {
        type: String,
        required: true,
        default: "Unknown"
    },

    description: {
        type: String,
        required: true
    },

    publishedBy:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    likes:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Likes"
    },

    bestSeller:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "bestSeller",
    },

    favourite:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Favourite"
    }


},{timestamps: true})

const Books = mongoose.model("Books", bookSchema)

export {Books}