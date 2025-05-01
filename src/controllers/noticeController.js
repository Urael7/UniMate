const noticeService = require('../services/noticeService');

const createNotice = async (req, res) => {
  try {
    const notice = await noticeService.createNotice(req);
    res.status(201).json(notice);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const getAllNotices = async (req, res) => {
  try {
    const notices = await noticeService.getAllNotices();
    res.json(notices);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getNoticeById = async (req, res) => {
  try {
    const notice = await noticeService.getNoticeById(req.params.id);
    if (!notice) return res.status(404).json({ message: 'Notice not found' });
    res.json(notice);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateNotice = async (req, res) => {
  try {
    const updated = await noticeService.updateNotice(req.params.id, req.body);
    if (!updated) return res.status(404).json({ message: 'Notice not found' });
    res.json(updated);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const deleteNotice = async (req, res) => {
  try {
    const deleted = await noticeService.deleteNotice(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Notice not found' });
    res.json({ message: 'Notice deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createNotice,
  getAllNotices,
  getNoticeById,
  updateNotice,
  deleteNotice
};
