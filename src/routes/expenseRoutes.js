const express = require('express');
const router = express.Router();
const expenseController = require('../controllers/expenseController');
const isAuthenticated = require("../middleware/auth");

router.post('/', isAuthenticated, expenseController.createExpense);
router.get('/', isAuthenticated, expenseController.getAllExpenses);
router.get('/:id', isAuthenticated, expenseController.getExpenseById);
router.put('/:id', isAuthenticated, expenseController.updateExpense);
router.delete('/:id', isAuthenticated, expenseController.deleteExpense);

module.exports = router;
