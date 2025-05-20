const express = require('express');
const app = express();
const routes = require('./app/routes');
const { sequelize } = require('./app/models');

app.use(express.json());
app.use('/api', routes);

sequelize.authenticate()
  .then(() => {
    console.log('Connection to the database has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

module.exports = app;