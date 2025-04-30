const express = require("express");
const router = express.Router();
const eventController = require('../controllers/eventController');
const isAuthenticated = require("../middleware/auth");

router.post('/',isAuthenticated, eventController.createEvent);
router.get('/', isAuthenticated, eventController.getAllEvents);
router.get('/:id', isAuthenticated, eventController.getEventById);
router.put('/:id', isAuthenticated, eventController.updateEvent);
router.delete('/:id', isAuthenticated,  eventController.deleteEvent);

module.exports = router;