import mongoose, {Schema} from "mongoose";
import jwt from "jsonwebtoken";
// import bcrypt from "bcrypt";

const userSchema = new Schema({
    username: {
        type: String,
        required: true,
        lowercase: true,
        trim: true,
        unique: true,
        index: true
    },

    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        index: true
    },

    books: {
        type: Schema.Types.ObjectId,
        ref: "Books"
    },

    password: {
        type: String,
        required: [true, "password is required"]
    },

    refreshToken: {
        type: String
    }
}, {timestamps:true})

// userSchema.pre("save", async function (next) {
//     if (!this.isModified("password")) return next();

//     const password = await bcrypt.hash(this.password, 10);
//     next();
// })

// userSchema.methods.isPasswordCorrect = async function (password) {
//     return await bcrypt.compare(password, this.password)
// }

userSchema.methods.generateAccessToken = function(){
    return jwt.sign(
        {
            _id: this._id,
            email: this.email,
            username: this.userName
        },
        process.env.ACCESS_TOKEN_SECRET,
        {
            expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
        }
    )
}

userSchema.methods.generateRefreshToken = function(){
    return jwt.sign(
        {
            _id: this._id,
        },
        process.env.REFRESH_TOKEN_SECRET,
        {
            expiresIn: process.env.REFRESH_TOKEN_EXPIRY
        }
    )
}

const User = mongoose.model("User", userSchema)

export {User}