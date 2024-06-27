import { app } from "./app.js";
import dotenv from "dotenv";
import { connectDB } from "./db/index.js";

dotenv.config({
    path: './.env'
})


const port = 8000;
connectDB()
.then(() => {
    app.listen( process.env.PORT , () => { 
        console.log(`⚙️ Server is running at port :${process.env.PORT}`);
    })
})
.catch((err) => {
    console.log("MONGO db connection failed !!! ", err);
})