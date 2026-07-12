import mysql from "mysql2/promise";
import fs from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function runMigration() {
  const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "",
    database: "project_ems",
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
  });

  try {
    console.log("🔄 Running system settings migration...");

    const sqlPath = join(
      __dirname,
      "db",
      "migrations",
      "add_system_settings.sql",
    );
    const sql = fs.readFileSync(sqlPath, "utf8");

    // Split by semicolon and filter out empty statements
    const statements = sql
      .split(";")
      .map((s) => s.trim())
      .filter((s) => s.length > 0);

    for (const statement of statements) {
      console.log(`Executing: ${statement.substring(0, 50)}...`);
      await pool.query(statement);
    }

    console.log("✅ Migration completed successfully!");

    // Verify the results
    const [rows] = await pool.query("SELECT * FROM system_settings");
    console.log("\n📊 System settings table contents:");
    console.table(rows);
  } catch (error) {
    console.error("❌ Migration failed:", error.message);
    process.exit(1);
  } finally {
    await pool.end();
    process.exit(0);
  }
}

runMigration();
