const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    photo: {
      type: String,
      default: ""
    },
    phone: {
      type: String,
    },
    major: {
      type: String,
    },
    bio: {
      type: String,
      maxlength: 500
    },
    year: {
      type: String, // e.g., "1st year", "2nd year", etc.
  }},
  { timestamps: true }

);

const User = mongoose.model("User", userSchema);

module.exports = User;

// Hash the password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// Compare password method for login
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};