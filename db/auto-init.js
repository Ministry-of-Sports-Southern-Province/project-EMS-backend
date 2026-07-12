import mysql from "mysql2/promise";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
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

/**
 * Checks if database exists and has tables
 */
async function checkDatabaseExists() {
  const connection = await mysql.createConnection({
    host: DB_CONFIG.host,
    port: DB_CONFIG.port,
    user: DB_CONFIG.user,
    password: DB_CONFIG.password,
  });

  try {
    // Check if database exists
    const [databases] = await connection.query(
      "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = ?",
      [DB_CONFIG.database]
    );

    if (databases.length === 0) {
      return false;
    }

    // Check if database has tables
    await connection.query(`USE \`${DB_CONFIG.database}\``);
    const [tables] = await connection.query(
      "SELECT COUNT(*) as count FROM information_schema.TABLES WHERE TABLE_SCHEMA = ?",
      [DB_CONFIG.database]
    );

    return tables[0].count > 0;
  } finally {
    await connection.end();
  }
}

/**
 * Auto-initializes database if it doesn't exist
 */
async function autoInitialize() {
  console.log("\n🔍 Checking database status...");

  const exists = await checkDatabaseExists();

  if (exists) {
    console.log(`✓ Database '${DB_CONFIG.database}' is ready\n`);
    return;
  }

  console.log(`⚠ Database '${DB_CONFIG.database}' not found or empty`);
  console.log("🚀 Auto-initializing database...\n");

  const connection = await mysql.createConnection({
    host: DB_CONFIG.host,
    port: DB_CONFIG.port,
    user: DB_CONFIG.user,
    password: DB_CONFIG.password,
    multipleStatements: true,
  });

  try {
    // Create database
    await connection.query(
      `CREATE DATABASE IF NOT EXISTS \`${DB_CONFIG.database}\``
    );
    await connection.query(`USE \`${DB_CONFIG.database}\``);

    // Load and execute schema
    const schemaPath = path.join(__dirname, "project_ems_latest2.sql");
    const schemaSql = await fs.readFile(schemaPath, "utf8");
    await connection.query(schemaSql);

    console.log("✓ Database initialized successfully using project_ems_latest2.sql\n");
  } finally {
    await connection.end();
  }
}

export default autoInitialize;
