import con from "./config/db.config.js";

async function testInsert() {
  try {
    console.log("Testing employee_document insert...");

    // Get a valid employee ID
    const [employees] = await con.query("SELECT id FROM employee LIMIT 1");
    if (employees.length === 0) {
      console.log("❌ No employees found");
      return;
    }
    const empId = employees[0].id;
    console.log("Using employee ID:", empId);

    // Get a valid document type ID
    const [docTypes] = await con.query("SELECT id FROM document_type LIMIT 1");
    if (docTypes.length === 0) {
      console.log("❌ No document types found");
      return;
    }
    const docTypeId = docTypes[0].id;
    console.log("Using document type ID:", docTypeId);

    // Try to insert
    const [result] = await con.query(
      "INSERT INTO employee_document (fk_emp_id, fk_document_type_id, instance_index, page_count, cloudinary_url) VALUES (?, ?, ?, ?, ?)",
      [empId, docTypeId, 1, 10, "http://test.url/image.jpg"]
    );

    console.log("✓ Insert successful!");
    console.log("Insert ID:", result.insertId);
    console.log("Affected rows:", result.affectedRows);

    // Verify the record
    const [records] = await con.query(
      "SELECT * FROM employee_document WHERE id = ?",
      [result.insertId]
    );
    console.log("Inserted record:", records[0]);

    // Clean up
    await con.query("DELETE FROM employee_document WHERE id = ?", [
      result.insertId,
    ]);
    console.log("✓ Test record deleted");
  } catch (error) {
    console.error("❌ Error:", error.message);
    console.error("Error code:", error.code);
    console.error("SQL State:", error.sqlState);
  } finally {
    process.exit(0);
  }
}

testInsert();
