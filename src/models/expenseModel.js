const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const ExpenseSchema = new Schema({
  user: { 
    type: Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  amount: { 
    type: Number, 
    required: true 
  },
  category: { 
    type: String, 
    required: true 
  },
  description: {
    type: String,
    maxlength: 200
  },
  date: { 
    type: Date, 
    default: Date.now 
  }
});

module.exports = mongoose.model('Expense', ExpenseSchema);