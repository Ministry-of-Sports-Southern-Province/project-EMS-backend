import mysql from "mysql2/promise";
import { fileURLToPath } from "url";
import path from "path";
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configuration
const DB_CONFIG = {
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "sports_hrms",
};

async function autoInitialize() {
  console.log("\n🔍 Checking database status...");
  try {
    const connection = await mysql.createConnection({
      host: DB_CONFIG.host,
      port: DB_CONFIG.port,
      user: DB_CONFIG.user,
      password: DB_CONFIG.password,
      database: DB_CONFIG.database,
    });
    await connection.end();
    console.log(`✓ Database '${DB_CONFIG.database}' is ready\n`);
  } catch (err) {
    console.error("❌ Database connection failed:", err.message);
    throw err;
  }
}

export default autoInitialize;
