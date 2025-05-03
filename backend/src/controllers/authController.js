const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const User = require("../models/userModel");
const sendEmail = require("../utils/sendEmail");
const cloudinary = require("../utils/cloudinary")

// Generate JWT
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: "30d" });
};

// Signup Controller
const signupUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty())
    return res.status(400).json({ errors: errors.array() });
  const { name, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({ name, email, password: hashedPassword });
    res.status(201).json({
      _id: user._id,
      name: user.name,
      email: user.email,
      token: generateToken(user._id),
    });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Login Controller
const loginUser = async (req, res) => {
   const errors = validationResult(req);
  if (!errors.isEmpty())
    return res.status(400).json({ errors: errors.array() });
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (user && (await bcrypt.compare(password, user.password))) {
      res.json({
        _id: user._id,
        name: user.name,
        email: user.email,
        token: generateToken(user._id),
      });
    } else {
      res.status(400).json({ message: "Invalid credentials" });
    }
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Request Password Reset Controller
const requestReset = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: "User not found" });

    const token = crypto.randomBytes(32).toString("hex");
    user.resetToken = token;
    user.resetTokenExpiry = Date.now() + 1000 * 60 * 10; // 10 mins
    await user.save();

    const resetLink = `http://localhost:3000/reset-password/${token}`;
    await sendEmail(
      email,
      "Reset Your Password",
      `<p>Click <a href="${resetLink}">here</a> to reset your password.</p>`
    );

    res.json({ message: "Reset link sent" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Failed to send reset email", error: error.message });
  }
};

// Reset Password Controller
const resetPassword = async (req, res) => {
  const { token, newPassword } = req.body;
  try {
    const user = await User.findOne({
      resetToken: token,
      resetTokenExpiry: { $gt: Date.now() },
    });

    if (!user)
      return res.status(400).json({ message: "Token invalid or expired" });

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetToken = undefined;
    user.resetTokenExpiry = undefined;
    await user.save();

    res.json({ message: "Password reset successful" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
// controllers/userController.js


const uploadProfilePhoto = async (req, res) => {
  try {
    const userId = req.params.id;
    const file = req.file;

    // Check if file exists
    if (!file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }
let image
    // Call the service function to upload the file to Cloudinary
    await cloudinary.uploader.upload(file.path, function(err,result){
      if(err){
        console.log(err)

      }
       image = result.secure_url
       console.log(image)

    })
    if (image){
    // Update user with the photo URL in the database
    const user= await User.findById(userId)
    user.photo = image
    await user.save()
    res.status(200).json(user);}


    
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


// Export all at the end 
module.exports = {
  signupUser,
  loginUser,
  requestReset,
  resetPassword,
  generateToken,
  uploadProfilePhoto
};
