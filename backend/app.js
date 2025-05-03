const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();// ← Load .env variables
const passport = require("passport");
const connectDB = require('./src/config/db');

const app = express();

// ─── PASSPORT CONFIGURATION ───────────────────────────────────────────────────
require("./src/config/passport"); // ← Import Google OAuth strategy

// Middleware
app.use(passport.initialize()); // ← Initialize Passport
app.use(cors()); // ← Enable CORS
app.use(express.json()); // ← Parse incoming JSON

// Basic route to check if server works
app.get("/", (req, res) => {
  res.send("Backend is running ✅");
});

// ─── DATABASE CONNECTION 
connectDB();


  // === Import Routes ===
const authRoutes = require("./src/routes/authRoutes");
const eventRoutes = require("./src/routes/eventRoutes");
const expenseRoutes = require("./src/routes/expenseRoutes");
const noticeRoutes = require("./src/routes/noticeRoutes");
const taskRoutes = require("./src/routes/taskRoutes");
const resourceRoutes = require("./src/routes/resourceRoutes");
// === Use Routes ===
app.use("/api/user", authRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/expenses", expenseRoutes);
app.use("/api/notices", noticeRoutes);
app.use("/api/tasks", taskRoutes);
app.use("/api/resources", resourceRoutes);
// Start server

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));