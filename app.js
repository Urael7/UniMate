const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();
const connectDB = require('./src/config/db');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Basic route to check if server works
app.get("/", (req, res) => {
  res.send("Backend is running ✅");
});

connectDB();


  // === Import Routes ===
const authRoutes = require("./src/routes/authRoutes");
const eventRoutes = require("./src/routes/eventRoutes");
const expenseRoutes = require("./src/routes/expenseRoutes");
const noticeRoutes = require("./src/routes/noticeRoutes");
const taskRoutes = require("./src/routes/taskRoutes");

// === Use Routes ===
app.use("/api/user", authRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/expenses", expenseRoutes);
app.use("/api/notices", noticeRoutes);
app.use("/api/tasks", taskRoutes);

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));