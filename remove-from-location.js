import pool from "./config/db.config.js";

async function removeFromLocation() {
  try {
    console.log("Checking if from_location column exists...");
    const [columns] = await pool.query(
      `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
       WHERE TABLE_SCHEMA = DATABASE() 
       AND TABLE_NAME = 'employee_transfer' 
       AND COLUMN_NAME = 'from_location'`,
    );

    if (columns.length > 0) {
      console.log("Removing from_location column...");
      await pool.query(
        "ALTER TABLE employee_transfer DROP COLUMN from_location",
      );
      console.log("✅ Successfully removed from_location column");
    } else {
      console.log("✅ Column from_location does not exist, no action needed");
    }
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
}

removeFromLocation();
