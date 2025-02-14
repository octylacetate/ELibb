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

    genre: {
        type: String,
        required: true,
        enum: ['Fantasy', 'Sci-fi', 'Mystery', 'Romance', 'Historical-fi', 'Thriller', 'Non-fiction', 'Young-adult', "Children's-literature"],
        default: 'Fantasy'
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
    },

    recentlyViewedBy: [{
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User"
        },
        viewedAt: {
            type: Date,
            default: Date.now
        }
    }],

    progress: {
        type: Number,
        default: 0
    }

},{timestamps: true})

const Books = mongoose.model("Books", bookSchema)

export {Books}