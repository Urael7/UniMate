const jwt = require("jsonwebtoken");
module.exports = function isAuthenticated(req, res, next) {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.replace("Bearer ", "");
  if (!token) return res.status(401).json({ message: "No token provided" });
  try {
    const { id } = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { id };
    next();
  } catch {
    res.status(401).json({ message: "Invalid or expired token" });
  }
};
