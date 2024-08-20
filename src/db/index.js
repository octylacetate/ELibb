import mongoose from "mongoose";


const connectDB = async () => {
    try {
        const connectionInstance = await mongoose.connect("mongodb+srv://aoctyl:UQ2mIHQTimqBbSmD@cluster0.freisob.mongodb.net/Elib3?retryWrites=true&w=majority&appName=Cluster0")
        console.log(`\n MongoDB connected !! DB HOST: ${connectionInstance.connection.host}`);
    } catch (error) {   
        console.log("MONGODB connection FAILED ", error);
        process.exit(1)
    }
}

export {connectDB}
