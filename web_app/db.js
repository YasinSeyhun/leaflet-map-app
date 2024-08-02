require('dotenv').config();
const { Pool } = require('pg');

console.log('Database connection details:', {
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

pool.connect((err, client, release) => {
  if (err) {
    return console.error('Client edinilirken hata oluştu', err.stack);
  }
  console.log('Database ile bağlantı kuruldu');
});

module.exports = pool;
