import mysql from "mysql2/promise";
// Create connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || "sportshro",
  password: process.env.DB_PASSWORD || "86Dnl&9g9",
  database: process.env.DB_NAME || "sports_hrms",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
});

export default pool;
