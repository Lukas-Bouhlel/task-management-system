const express = require('express');
const app = express();
const routes = require('./app/routes');
const { sequelize } = require('./app/models');
const logger = require('./logger');

app.use(express.json());

app.use((req, res, next) => {
  res.on('finish', () => {
    logger.info({
      method: req.method,
      url: req.originalUrl,
      status: res.statusCode,
      ip: req.ip,
      timestamp: new Date().toISOString()
    });
  });
  next();
});

app.use('/api', routes);

sequelize.authenticate()
  .then(() => {
    console.log('Connection to the database has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

module.exports = app;