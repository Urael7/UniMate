const express = require('express');
const router = express.Router();
const noticeController = require('../controllers/noticeController');
const isAuthenticated = require("../middleware/auth");

router.post('/', isAuthenticated, noticeController.createNotice);
router.get('/', isAuthenticated, noticeController.getAllNotices);
router.get('/:id', isAuthenticated, noticeController.getNoticeById);
router.put('/:id', isAuthenticated, noticeController.updateNotice);
router.delete('/:id', isAuthenticated, noticeController.deleteNotice);

module.exports = router;