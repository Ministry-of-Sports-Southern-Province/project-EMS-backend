import connection from "./config/db.config.js";

async function testQuery() {
  try {
    const query = `SELECT et.*, e.name_with_init as employee_name, e.nic as employee_nic, e.email, e.photo as photo_url, jr.name as job_role_name, jc.class_code 
      FROM employee_transfer et JOIN employee e ON et.fk_emp_id = e.id 
      LEFT JOIN employee_career ec ON e.id = ec.fk_emp_id AND ec.end_date IS NULL 
      LEFT JOIN job_role_class jrc ON ec.fk_job_role_class_id = jrc.id 
      LEFT JOIN job_role jr ON jrc.fk_job_role_id = jr.id 
      LEFT JOIN job_class jc ON jrc.fk_job_class_id = jc.id WHERE 1=1 ORDER BY et.transfer_date DESC, et.created_at DESC`;
    
    const [transfers] = await connection.query(query);
    console.log("Query successful!");
    console.log(`Found ${transfers.length} transfers`);
  } catch (error) {
    console.error("Query failed:", error.message);
  }
  process.exit(0);
}

testQuery();
