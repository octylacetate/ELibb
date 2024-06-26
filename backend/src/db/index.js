import mongoose from "mongoose";


const connectDB = async () => {
    try {
        const connectionInstance = await mongoose.connect("mongodb+srv://muhammadsoban490:VeF0voKbIPtUx0tT@cluster0.e82p2ep.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
        console.log(`\n MongoDB connected !! DB HOST: ${connectionInstance.connection.host}`);
    } catch (error) {
        console.log("MONGODB connection FAILED ", error);
        process.exit(1)
    }
}

export {connectDB}
