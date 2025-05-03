const Event = require('../models/eventModel');
const cloudinary = require('../utils/cloudinary');

const createEvent = async (req) => {
  const user = req.user;
  const { title, date, description } = req.body;

  // Ensure a file is uploaded
  if (!req.file) {
    throw new Error('Photo is required');
  }

  // Upload photo to Cloudinary
  const uploadResult = await cloudinary.uploader.upload(req.file.path);
  const photo = uploadResult.secure_url;

  // Create and return the event
  const event = await Event.create({
    title,
    date,
    description,
    photo, // <-- Save photo URL here
    createdBy: user._id,
    participants: [user._id], // assuming it's an array
  });

  return event;
};



const getAllEvents = async () => {
  return await Event.find()
    .populate('createdBy', 'name email')
    .populate('participants', 'name email');
};

const getEventById = async (id) => {
  return await Event.findById(id)
    .populate('createdBy', 'name email')
    .populate('participants', 'name email');
};

const updateEvent = async (id, data) => {
  return await Event.findByIdAndUpdate(id, data, { new: true });
};

const deleteEvent = async (id) => {
  return await Event.findByIdAndDelete(id);
};

module.exports = {
  createEvent,
  getAllEvents,
  getEventById,
  updateEvent,
  deleteEvent
};
