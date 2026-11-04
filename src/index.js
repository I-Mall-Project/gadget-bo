import dotenv from "dotenv";
dotenv.config();

import { v2 as cloudinary } from "cloudinary";
import cookieParser from "cookie-parser";
import cors from "cors";
import express from "express";
import allRoutes from "./routes/index.js";

const app = express();

// Body parser limit 50mb kore din jate boro base64 image accept kore
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Cloudinary configuration
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// 🚀 CORS Configuration - Allow Localhost 3000 & 127.0.0.1:3000
const allowedOrigins = [
  "http://localhost:3000",
  "http://127.0.0.1:3000",
   "http://localhost:3001",
   "https://fashion-fo.vercel.app"
 
].filter(Boolean);

app.use(
  cors({
    origin: function (origin, callback) {
      // Allow requests with no origin (like mobile apps, curl, or backend-to-backend fetch)
      if (!origin || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      return callback(new Error("CORS not allowed for this origin"));
    },
    credentials: true,
  })
);

app.use(cookieParser());
app.use(express.static("public"));
app.use(express.json());

// Routes
app.get("/", (req, res) => {
  res.json({ msg: "Cosmetics API is working..." });
});

app.use("/api", allRoutes);

const port = process.env.PORT || 8000;

app.listen(port, () => {
  console.log(`Cosmetics API is working on port ${port}`);
});