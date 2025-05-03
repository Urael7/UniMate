const Resource = require('../models/resourceModel');
const cloudinary = require("../utils/cloudinary")

exports.uploadResource = async (req, res) => {
  try {
    const file = req.file;
    const userId = req.user._id;

    if (!file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }
let files
    // Call the service function to upload the file to Cloudinary
    await cloudinary.uploader.upload(file.path, function(err,result){
      if(err){
        console.log(err)

      }
       files = result.secure_url
       console.log(file)

    })
 
    // Update user with the photo URL in the database
  
   

    const newResource = new Resource({
      title: req.body.title,
      description: req.body.description,
      fileUrl: files,
      uploadedBy: userId,
      type: req.body.type || 'pdf',
    });

    await newResource.save();

    res.status(201).json(newResource);
  } catch (err) {
    console.log(err)
    res.status(500).json({ message: err.message });
  }
};

exports.getResources = async (req, res) => {
  try {
    const resources = await Resource.find().populate('uploadedBy', 'name email');
    res.status(200).json(resources);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
