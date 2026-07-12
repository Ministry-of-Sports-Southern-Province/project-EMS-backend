import connection from "./config/db.config.js";

async function verifyMigration() {
  try {
    const [tables] = await connection.query("SHOW TABLES LIKE 'employee_transfer'");
    console.log("employee_transfer table exists:", tables.length > 0);
    
    const [columns] = await connection.query("SHOW COLUMNS FROM employee WHERE Field = 'transfer_status'");
    console.log("transfer_status column exists:", columns.length > 0);
    
    if (columns.length > 0) {
      console.log("Column details:", columns[0]);
    }
    
    process.exit(0);
  } catch (error) {
    console.error("Verification failed:", error.message);
    process.exit(1);
  }
}

verifyMigration();
