const Expense = require('../models/expenseModel');

const createExpense = async (req) => {
  const User = req.user
  const {amount, date, category} = req.body
    await Expense.create({
      amount, date,category,
      user:User._id
    })
};

const getAllExpenses = async () => {
  return await Expense.find().populate('user', 'name email');
};

const getExpenseById = async (id) => {
  return await Expense.findById(id).populate('user', 'name email');
};

const updateExpense = async (id, data) => {
  return await Expense.findByIdAndUpdate(id, data, { new: true });
};

const deleteExpense = async (id) => {
  return await Expense.findByIdAndDelete(id);
};

module.exports = {
  createExpense,
  getAllExpenses,
  getExpenseById,
  updateExpense,
  deleteExpense
};
