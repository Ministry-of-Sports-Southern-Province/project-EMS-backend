import mysql from "mysql2/promise";
import fs from "fs";

async function runMigration() {
  console.log("Starting admin table migration...\n");

  const sql = fs.readFileSync("db/migrations/update_admin_table.sql", "utf8");

  const connection = await mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "project_ems",
    multipleStatements: true,
  });

  try {
    console.log("Executing migration...");
    await connection.query(sql);
    console.log("✓ Migration executed successfully!\n");

    // Verify the changes
    const [columns] = await connection.query(`
      SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = 'project_ems' AND TABLE_NAME = 'admin'
      ORDER BY ORDINAL_POSITION
    `);

    console.log("=== Admin Table Structure ===");
    console.table(columns);

    const [admin] = await connection.query(
      "SELECT id, email, created_at, updated_at FROM admin LIMIT 1"
    );
    console.log("\n=== Admin Record ===");
    console.table(admin);
  } catch (error) {
    console.error("❌ Migration failed:", error.message);
    console.error(error);
  } finally {
    await connection.end();
  }
}

runMigration();
