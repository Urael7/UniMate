const passport = require("passport");
const GoogleStrategy = require("passport-google-oauth20").Strategy;
const User = require("../models/userModel");

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "/api/auth/google/callback",
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        // Find user by Google ID
        let user = await User.findOne({ googleId: profile.id });

        if (!user) {
          // If user doesn't exist, create one
          user = await User.create({
            name: profile.displayName,
            email: profile.emails[0].value,
            googleId: profile.id,
          });
        }

        // Return the user to complete the authentication process
        return done(null, user);
      } catch (err) {
        return done(err, null);
      }
    }
  )
);
