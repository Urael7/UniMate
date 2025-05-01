const Task = require('../models/taskModel');

const createTask = async (req) => {
  const User = req.user
  const {title, dueDate} = req.body
  await Task.create({
    title,dueDate,
    user:User._id
  })
};

const getAllTasks = async () => {
  return await Task.find().populate('user');
};

const getTaskById = async (id) => {
  return await Task.findById(id).populate('user');
};

const updateTask = async (id, data) => {
  return await Task.findByIdAndUpdate(id, data, { new: true });
};

const deleteTask = async (id) => {
  return await Task.findByIdAndDelete(id);
};

module.exports = {
  createTask,
  getAllTasks,
  getTaskById,
  updateTask,
  deleteTask
};
