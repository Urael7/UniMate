const express = require('express');
const router = express.Router();
const upload = require('../middleware/multer');
const { uploadResource, getResources } = require('../controllers/resourceController');
const isAuthenticated = require("../middleware/auth");

// Upload a new resource
router.post('/', isAuthenticated, upload.single('file'), uploadResource);

// Get all resources
router.get('/', getResources);

module.exports = router;