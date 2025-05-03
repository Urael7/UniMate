const eventService = require('../services/eventService');
const Event = require('../models/eventModel');
const cloudinary = require("../utils/cloudinary")

const createEvent = async (req, res) => {
  try {
    const event = await eventService.createEvent(req);
    res.status(201).json(event);
  } catch (error) {
    console.error('Error creating event:', error);
    res.status(400).json({ error: error.message });
  }
};



const getAllEvents = async (req, res) => {
  try {
    const events = await eventService.getAllEvents();
    res.json(events);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getEventById = async (req, res) => {
  try {
    const event = await eventService.getEventById(req.params.id);
    if (!event) return res.status(404).json({ message: 'Event not found' });
    res.json(event);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateEvent = async (req, res) => {
  try {
    const updated = await eventService.updateEvent(req.params.id, req.body);
    if (!updated) return res.status(404).json({ message: 'Event not found' });
    res.json(updated);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const deleteEvent = async (req, res) => {
  try {
    const deleted = await eventService.deleteEvent(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Event not found' });
    res.json({ message: 'Event deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

//controllers/eventController.js


const uploadEventPhoto = async (req, res) => {
  try {
    const eventId = req.params.eventId;
    const file = req.file;

    // Check if file exists
    if (!file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    // Upload the photo to Cloudinary
    const uploadResult = await uploadPhotoToCloudinary(file);

    // Update the event with the uploaded photo URL
    const updatedEvent = await Event.findByIdAndUpdate(
      eventId,
      { photo: uploadResult.secure_url },
      { new: true }
    );

    res.status(200).json(updatedEvent);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};




module.exports = {
  createEvent,
  getAllEvents,
  getEventById,
  updateEvent,
  deleteEvent,
  uploadEventPhoto
};
