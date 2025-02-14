import mongoose from "mongoose";

const recentlyViewedSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    book: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Books",
        required: true
    },
    progress: {
        type: Number,
        default: 0
    }
}, { timestamps: true });

// Index to ensure a user can only have one entry per book
recentlyViewedSchema.index({ user: 1, book: 1 }, { unique: true });

const RecentlyViewed = mongoose.model("RecentlyViewed", recentlyViewedSchema);

export { RecentlyViewed }; 