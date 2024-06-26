import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";

const app = express();

app.use(cors({
    origin: 'http://localhost:65519' ,   //frontend ki port dlni
    credentials: true 
}));
app.use(express.json({limit:"16kb"}));
app.use(express.urlencoded({
    limit:"16kb",
    extended: true
}));
app.use(express.static("public"));
app.use(cookieParser());


//routes import
import userRouter from './routes/user.routes.js'


//routes declaration
app.use("/api/v1/users", userRouter)




export {app} 