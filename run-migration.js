import mysql from "mysql2/promise";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import fs from "fs";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function runMigration() {
  let connection;

  try {
    console.log("Connecting to database...");
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || "localhost",
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || "root",
      password: process.env.DB_PASSWORD || "",
      database: process.env.DB_NAME || "project_ems",
    });

    console.log("Connected successfully!");
    console.log("Running migration: add_admin_is_active.sql");

    // Execute migration statements directly
    const statements = [
      "ALTER TABLE `admin` ADD COLUMN `is_active` TINYINT(1) NOT NULL DEFAULT 1 AFTER `password_hash`",
      "UPDATE `admin` SET `is_active` = 1",
    ];

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      console.log(
        `\n[${i + 1}/${statements.length}] Executing:`,
        statement.substring(0, 60) + "...",
      );
      try {
        await connection.query(statement);
        console.log("✓ Success");
      } catch (error) {
        if (error.code === "ER_DUP_FIELDNAME") {
          console.log("⚠️  Column already exists, skipping...");
        } else {
          throw error;
        }
      }
    }

    console.log("\n✅ Migration completed successfully!");
    console.log("\nVerifying changes...");

    // Verify the column was added
    const [columns] = await connection.query(
      "SHOW COLUMNS FROM admin WHERE Field = 'is_active'",
    );

    if (columns.length > 0) {
      console.log("✓ is_active column exists");
      console.log("  Type:", columns[0].Type);
      console.log("  Default:", columns[0].Default);
    }

    // Check admin records
    const [admins] = await connection.query(
      "SELECT id, email, is_active FROM admin",
    );
    console.log(`\n✓ Found ${admins.length} admin account(s):`);
    admins.forEach((admin) => {
      console.log(
        `  - ${admin.email}: ${admin.is_active === 1 ? "Active" : "Inactive"}`,
      );
    });
  } catch (error) {
    console.error("\n❌ Migration failed:", error.message);
    if (error.code === "ER_DUP_FIELDNAME") {
      console.log(
        "\nℹ️  The is_active column already exists. Migration may have been run previously.",
      );
    }
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
      console.log("\nDatabase connection closed.");
    }
  }
}

runMigration();
