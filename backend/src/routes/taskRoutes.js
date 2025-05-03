const express = require('express');
const router = express.Router();
const taskController = require('../controllers/TaskController');
const isAuthenticated = require("../middleware/auth");

router.post('/', isAuthenticated, taskController.createTask);
router.get('/', isAuthenticated, taskController.getAllTasks);
router.get('/:id', isAuthenticated, taskController.getTaskById);
router.put('/:id',isAuthenticated, taskController.updateTask);
router.delete('/:id', isAuthenticated, taskController.deleteTask);

module.exports = router;