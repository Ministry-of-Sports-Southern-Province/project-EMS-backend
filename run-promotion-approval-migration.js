import mysql from "mysql2/promise";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function runMigration() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    multipleStatements: true,
  });

  try {
    console.log("🚀 Starting Promotion Approval System Migration...\n");

    const sqlPath = path.join(
      __dirname,
      "db",
      "migrations",
      "add_promotion_approval_system.sql",
    );
    const sql = fs.readFileSync(sqlPath, "utf8");

    console.log("📄 Reading SQL migration file...");
    console.log(`   File: ${sqlPath}\n`);

    console.log("🔨 Executing migration...");
    await connection.query(sql);

    console.log("✅ Migration completed successfully!\n");

    // Verify tables were created
    console.log("🔍 Verifying tables...");
    const [tables] = await connection.query("SHOW TABLES LIKE 'promotion_%'");

    console.log(`   Found ${tables.length} tables:`);
    tables.forEach((table) => {
      const tableName = Object.values(table)[0];
      console.log(`   ✓ ${tableName}`);
    });

    console.log("\n📊 Table structures:");

    // Show promotion_application structure
    console.log("\n   promotion_application:");
    const [appFields] = await connection.query(
      "DESCRIBE promotion_application",
    );
    appFields.slice(0, 5).forEach((field) => {
      console.log(`     - ${field.Field} (${field.Type})`);
    });
    console.log(`     ... and ${appFields.length - 5} more fields`);

    // Show promotion_approval structure
    console.log("\n   promotion_approval:");
    const [approvalFields] = await connection.query(
      "DESCRIBE promotion_approval",
    );
    approvalFields.forEach((field) => {
      console.log(`     - ${field.Field} (${field.Type})`);
    });

    console.log("\n✨ All done! The promotion approval system is ready.\n");
    console.log("Next steps:");
    console.log("  1. Restart backend server if running");
    console.log("  2. Navigate to Promotion page in the app");
    console.log('  3. Click "Apply" button for eligible employees\n');
  } catch (error) {
    console.error("❌ Migration failed:", error.message);
    if (error.sql) {
      console.error("   SQL:", error.sql);
    }
    process.exit(1);
  } finally {
    await connection.end();
  }
}

runMigration();
