import pool from "../config/db.config.js";

async function autoInitialize() {
  console.log("\n🔍 Checking database status...");
  try {
    const connection = await pool.getConnection();
    connection.release();
    console.log("✓ Database is ready\n");
  } catch (err) {
    console.error("❌ Database connection failed:", err.message);
    throw err;
  }
}

export default autoInitialize;
