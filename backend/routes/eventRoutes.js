const express = require("express");
const router = express.Router();
const isAuthenticated = require("../middleware/auth");

router.get("/", isAuthenticated, (req, res) => {
  res.json({ message: `Hello ${req.user.id}, you’re authorized!` });
});

module.exports = router;
