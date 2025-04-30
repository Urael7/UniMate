const { truncates } = require('bcryptjs');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TaskSchema = new Schema({
  user: { 
    type: Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  title: {
    type: String,
    required : true
  },
  description : { 
    type: String, 
  },
  dueDate: { 
    type: Date, 
    required: true 
  },
  status: { 
    type: String, 
    enum: ['pending', 'completed'], 
    default: 'pending' 
  },
  isGroup: { 
    type: Boolean,
    default: false 
  }
});

module.exports = mongoose.model('TaskModel', TaskSchema);