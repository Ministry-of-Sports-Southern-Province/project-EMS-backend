import mysql from "mysql2/promise";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
import bcrypt from "bcrypt";
import dotenv from "dotenv";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configuration
const DB_CONFIG = {
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "project_ems",
};

/**
 * Manual Fresh Database Installation Script
 *
 * This script manually creates the database from scratch.
 * Note: The server now auto-initializes the database on startup,
 * so you typically don't need to run this manually.
 *
 * Use this only if you want to manually reset the database.
 *
 * Usage: node backend/db/migrations/fresh-install.js
 */

async function freshInstall() {
  console.log("\n");
  console.log("╔══════════════════════════════════════════╗");
  console.log("║   FRESH DATABASE INSTALLATION            ║");
  console.log("║   Project EMS - New Schema               ║");
  console.log("╚══════════════════════════════════════════╝");
  console.log("\n");

  const startTime = Date.now();

  // Create connection without database first
  const connection = await mysql.createConnection({
    host: DB_CONFIG.host,
    port: DB_CONFIG.port,
    user: DB_CONFIG.user,
    password: DB_CONFIG.password,
    multipleStatements: true,
  });

  try {
    // Step 1: Create database
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📦 Creating database...");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    await connection.query(`DROP DATABASE IF EXISTS \`${DB_CONFIG.database}\``);
    await connection.query(`CREATE DATABASE \`${DB_CONFIG.database}\``);
    await connection.query(`USE \`${DB_CONFIG.database}\``);

    console.log(`✓ Database '${DB_CONFIG.database}' created\n`);

    // Step 2: Load and execute schema
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🚀 Installing schema...");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    const schemaPath = path.join(__dirname, "..", "project_ems_new.sql");
    const schemaSql = await fs.readFile(schemaPath, "utf8");

    // Execute the schema
    await connection.query(schemaSql);

    console.log("✓ Schema installed successfully\n");

    // Step 3: Create default admin account
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("👤 Creating default admin account...");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    const defaultPassword = "1234";
    const passwordHash = await bcrypt.hash(defaultPassword, 10);

    await connection.query(
      "INSERT INTO admin (email, password_hash) VALUES (?, ?)",
      ["admin", passwordHash]
    );

    console.log("✓ Default admin created");
    console.log("  Email: admin");
    console.log("  Password: 1234");
    console.log("  ⚠ Please change this password after first login!\n");

    // Step 4: Insert initial lookup data
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 Inserting lookup data...");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    // Insert document types
    await connection.query(`
      INSERT INTO document_type (name) VALUES
        ('NIC'),
        ('Birth Certificate'),
        ('Educational Certificates'),
        ('Appointment Letter'),
        ('Service Records'),
        ('Medical Reports'),
        ('Performance Reports'),
        ('Training Certificates')
    `);

    // Insert job classes
    await connection.query(`
      INSERT INTO job_class (class_code, hierarchy_order) VALUES
        ('III', 3),
        ('II', 2),
        ('I', 1),
        ('Special', 0)
    `);

    console.log("✓ Lookup data inserted\n");

    // Step 5: Verify installation
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🔍 Verifying installation...");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

    const [tables] = await connection.query(
      `
      SELECT TABLE_NAME 
      FROM information_schema.TABLES 
      WHERE TABLE_SCHEMA = ?
      ORDER BY TABLE_NAME
    `,
      [DB_CONFIG.database]
    );

    console.log(`✓ Tables created: ${tables.length}`);
    tables.forEach((t) => console.log(`  - ${t.TABLE_NAME}`));

    const [adminCount] = await connection.query(
      "SELECT COUNT(*) as count FROM admin"
    );
    console.log(`\n✓ Admin accounts: ${adminCount[0].count}`);

    const [docTypes] = await connection.query(
      "SELECT COUNT(*) as count FROM document_type"
    );
    console.log(`✓ Document types: ${docTypes[0].count}`);

    const [jobClasses] = await connection.query(
      "SELECT COUNT(*) as count FROM job_class"
    );
    console.log(`✓ Job classes: ${jobClasses[0].count}`);

    // Success
    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log("\n");
    console.log("╔══════════════════════════════════════════╗");
    console.log("║   ✓ INSTALLATION COMPLETED               ║");
    console.log(
      `║   Duration: ${duration}s${" ".repeat(29 - duration.length)}║`
    );
    console.log("╚══════════════════════════════════════════╝");
    console.log("\n");
    console.log("✓ Database created and initialized");
    console.log("✓ Schema installed successfully");
    console.log("✓ Default admin account created");
    console.log("✓ Ready to use!\n");
  } catch (error) {
    console.error("\n");
    console.error("╔══════════════════════════════════════════╗");
    console.error("║   ✗ INSTALLATION FAILED                  ║");
    console.error("╚══════════════════════════════════════════╝");
    console.error("\n");
    console.error("Error:", error.message);
    console.error("\n");
    process.exit(1);
  } finally {
    await connection.end();
  }
}

// Execute installation
freshInstall()
  .then(() => {
    console.log("Exiting...\n");
    process.exit(0);
  })
  .catch((error) => {
    console.error("Fatal error:", error);
    process.exit(1);
  });
