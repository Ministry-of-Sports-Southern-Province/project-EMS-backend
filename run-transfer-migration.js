import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import connection from "./config/db.config.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function runMigration() {
  try {
    console.log("Running employee transfer system migration...");
    
    const migrationPath = join(
      __dirname,
      "db",
      "migrations",
      "add_employee_transfer_system.sql"
    );
    
    const sql = readFileSync(migrationPath, "utf8");
    const statements = sql
      .split(";")
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
    
    for (const statement of statements) {
      await connection.query(statement);
      console.log("Executed:", statement.substring(0, 50) + "...");
    }
    
    console.log("Migration completed successfully!");
    process.exit(0);
  } catch (error) {
    console.error("Migration failed:", error.message);
    process.exit(1);
  }
}

runMigration();
