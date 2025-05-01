const express = require("express");
const User = require("../models/User");

const { signupUser, loginUser } = require("../controllers/authController");
const router = express.Router();

router.post("/signup", signupUser);
router.post("/login", loginUser);

module.exports = router;
