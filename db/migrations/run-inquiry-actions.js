import mysql from "mysql2/promise";
import fs from "fs/promises";
import dotenv from "dotenv";

dotenv.config();

const DB_CONFIG = {
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "project_ems",
};

async function runMigration() {
  let connection;
  try {
    console.log("Connecting to database...");
    connection = await mysql.createConnection(DB_CONFIG);

    console.log("Adding inquiry action control columns...\n");

    // Add the three new columns
    const alterStatements = [
      {
        name: "hold_increment",
        sql: `ALTER TABLE employee_career 
              ADD COLUMN hold_increment TINYINT(1) DEFAULT 0 
              COMMENT 'Prevents salary increments when set to 1'`,
      },
      {
        name: "hold_salary",
        sql: `ALTER TABLE employee_career 
              ADD COLUMN hold_salary TINYINT(1) DEFAULT 0 
              COMMENT 'Suspends salary payments when set to 1'`,
      },
      {
        name: "disable_employment",
        sql: `ALTER TABLE employee_career 
              ADD COLUMN disable_employment TINYINT(1) DEFAULT 0 
              COMMENT 'Suspends employment status when set to 1'`,
      },
    ];

    for (const stmt of alterStatements) {
      try {
        console.log(`Adding column: ${stmt.name}...`);
        await connection.query(stmt.sql);
        console.log(`✓ Column '${stmt.name}' added successfully`);
      } catch (error) {
        if (error.code === "ER_DUP_FIELDNAME") {
          console.log(`⚠ Column '${stmt.name}' already exists, skipping...`);
        } else {
          throw error;
        }
      }
    }

    // Update existing records to ensure they have default values
    console.log("\nUpdating existing records...");
    await connection.query(`
      UPDATE employee_career 
      SET hold_increment = COALESCE(hold_increment, 0), 
          hold_salary = COALESCE(hold_salary, 0), 
          disable_employment = COALESCE(disable_employment, 0)
    `);
    console.log("✓ Existing records updated with default values");

    console.log("\n✓ Migration completed successfully!");

    // Verify the columns were added
    console.log("\nVerifying columns...");
    const [columns] = await connection.query(
      `SHOW COLUMNS FROM employee_career WHERE Field IN ('hold_increment', 'hold_salary', 'disable_employment')`
    );

    console.log(`\nFound ${columns.length} new columns:`);
    columns.forEach((col) => {
      console.log(`  - ${col.Field} (${col.Type})`);
    });
  } catch (error) {
    console.error("\n✗ Migration failed:");
    console.error(error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
      console.log("\nDatabase connection closed.");
    }
  }
}

runMigration();
