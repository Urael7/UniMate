const express = require("express");
const { body } = require("express-validator");
const passport = require("passport");
const upload = require('../middleware/multer'); // Multer middleware for file upload
// Route to upload profile photo


const { signupUser, loginUser ,requestReset,
    resetPassword,
    generateToken,uploadProfilePhoto} = require("../controllers/authController");

const router = express.Router();

// Google login route

// Google callback route
router.get(
    "/google",
    passport.authenticate("google", { scope: ["profile", "email"] })
  );
  
// Google callback route
router.get(
    "/google/callback",
    passport.authenticate("google", { session: false }), // Disable session-based login
    (req, res) => {
      // Generate JWT after successful login
      const token = generateToken(req.user._id); // generateToken is your JWT generation function
      res.json({ token, user: req.user });
    }
  );
  
  

// Signup and login with validation
router.post(
    "/signup",
    [
      body("name").notEmpty().withMessage("Name required"),
      body("email").isEmail().withMessage("Invalid email"),
      body("password").isLength({ min: 6 }).withMessage("Min 6 chars required"),
    ],
    signupUser
  );
  
  router.post(
    "/login",
    [body("email").isEmail(), body("password").notEmpty()],
    loginUser
  );
  
  // Password reset routes
  router.post("/request-reset", requestReset);
  router.post("/reset-password", resetPassword);
  
  router.post('/:id/photo', upload.single('image'), uploadProfilePhoto);

module.exports = router;