const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const app = express();

// ─── MIDDLEWARES ────────────────────────────────────────────────────────────
// Enable CORS
app.use(cors());
// Parse incoming JSON bodies
app.use(express.json());

// ─── ROUTES ─────────────────────────────────────────────────────────────────

const authRoutes = require("./routes/authRoutes");
const eventRoutes = require("./routes/eventRoutes");

// ─── MOUNT ROUTES ──────────────────────────────────────────────────────────────
// Auth endpoints:  /api/auth/signup, /api/auth/login
app.use("/api/auth", authRoutes);
// Event endpoints (protected by your auth middleware inside eventRoutes)
app.use("/api/events", eventRoutes);

// Basic health‐check route
app.get("/", (req, res) => {
  res.send("Backend is working ✅");
});

// ─── DATABASE CONNECTION ─────────────────────────────────────────────────────
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected ✅"))
  .catch((err) => console.error("MongoDB connection error:", err));

// ─── START SERVER ────────────────────────────────────────────────────────────
const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>
  console.log(`Server running on http://localhost:${PORT}`)
);
