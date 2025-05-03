const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const NoticeSchema = new Schema({
  title: { 
    type: String, 
    required: true,
    maxlength: 100
  },
  content: { 
    type: String, 
    required: true 
  },
  postedBy: { 
    type: Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
  tags: [String],
  expiryDate:{
    type : Date,
    default: () => new Date(Date.now() + 24 * 60 * 60 * 1000)
  },
}, { timestamps: true });

module.exports = mongoose.model('Notice', NoticeSchema);