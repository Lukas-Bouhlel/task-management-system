const Task = require('../models').Task;
const logger = require('../../logger');

exports.createTask = async (req, res) => {
  try {
    const task = await Task.create(req.body);
    res.status(201).json(task);
  } catch (error) {
    logger.error({
      message: error.message,
      route: req.originalUrl,
      method: req.method,
      ip: req.ip,
      stack: error.stack
    });
    res.status(400).json({ error: error.message });
  }
};