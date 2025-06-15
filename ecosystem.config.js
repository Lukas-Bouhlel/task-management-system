module.exports = {
  apps: [{
    name: "node-api",
    script: "./index.js",
    error_file: "./logs/err.log",
    out_file: "./logs/out.log",
    env_production: {
      NODE_ENV: "production",
    }
  }]
};