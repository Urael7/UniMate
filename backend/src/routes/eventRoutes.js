const express = require("express");
const router = express.Router();
const eventController = require('../controllers/eventController');
const isAuthenticated = require("../middleware/auth");
const { uploadEventPhoto } = require('../controllers/eventController');
const upload = require('../middleware/multer'); // Import Multer middleware



// Upload file with name "file"
router.post('/', isAuthenticated, upload.single('image'), eventController.createEvent);

module.exports = router;


// Route to upload event photo
router.post('/:eventId/photo',isAuthenticated, upload.single('image'), uploadEventPhoto);
//router.post('/',isAuthenticated, eventController.createEvent);
router.get('/', isAuthenticated, eventController.getAllEvents);
router.get('/:id', isAuthenticated, eventController.getEventById);
router.put('/:id', isAuthenticated, eventController.updateEvent);
router.delete('/:id', isAuthenticated,  eventController.deleteEvent);

module.exports = router;