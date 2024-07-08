import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import path from 'path';
import { fileURLToPath } from 'url';
const app = express();
// ES Module equivalents of __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use(cors({
    origin: 'http://localhost:55215' ,   //frontend ki port dlni
    credentials: true 
}));

app.use(express.json({limit:"16kb"}));
app.use(express.urlencoded({
    limit:"16kb",
    extended: true
}));
app.use(express.static(path.join(__dirname, '../public')));app.use(cookieParser());


//routes import
import userRouter from './routes/user.routes.js';
import booksRouter from './routes/books.routes.js';
import favouriteRouter from './routes/favourite.routes.js';
import reviewRouter from './routes/reviews.routes.js';

//routes declaration
app.use("/api/v1/users", userRouter)
app.use("/api/v1/books", booksRouter)
app.use("/api/v1/favourite", favouriteRouter)
app.use("/api/v1/reviews", reviewRouter)



export {app} 