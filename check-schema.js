import connection from "./config/db.config.js";

async function checkSchema() {
  try {
    const [columns] = await connection.query("SHOW COLUMNS FROM employee");
    console.log("Employee table columns:");
    columns.forEach(col => {
      console.log(`- ${col.Field} (${col.Type})`);
    });
  } catch (error) {
    console.error("Error:", error.message);
  }
  process.exit(0);
}

checkSchema();
