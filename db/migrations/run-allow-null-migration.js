import con from "../../config/db.config.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function runMigration() {
  try {
    console.log("Running migration: Allow NULL for cloudinary_url...");

    const sqlPath = path.join(__dirname, "allow_null_cloudinary_url.sql");
    const sql = fs.readFileSync(sqlPath, "utf8");

    const statements = sql
      .split(";")
      .map((s) => s.trim())
      .filter((s) => s.length > 0);

    for (const statement of statements) {
      console.log("Executing:", statement.substring(0, 80) + "...");
      await con.query(statement);
      console.log("✓ Done");
    }

    console.log("\n✓ Migration completed successfully!");
    process.exit(0);
  } catch (error) {
    console.error("❌ Migration failed:", error.message);
    process.exit(1);
  }
}

runMigration();
