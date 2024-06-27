import { app } from "./app.js";
import dotenv from "dotenv";
import { connectDB } from "./db/index.js";

dotenv.config({
    path: './.env'
})

connectDB()
.then(() => {
    app.listen( port, () => { 
        console.log(`⚙️ Server is running at port :${port}`);
    })
})
.catch((err) => {
    console.log("MONGO db connection failed !!! ", err);
})