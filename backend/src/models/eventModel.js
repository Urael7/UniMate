const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const EventSchema = new Schema({
  createdBy: { 
    type: Schema.Types.ObjectId, 
    ref: 'User', 
  },
  title: { 
    type: String, 
    required: true 
  },
  description: String,
  date: { 
    type: Date, 
    required: true 
  },  
  photo: {
    type: String,
    default: ""
  }, 
  participants: [{ 
    type: Schema.Types.ObjectId, 
    ref: 'User' 
  }]
});

 const Event = mongoose.model('Event', EventSchema);
 module.exports=Event