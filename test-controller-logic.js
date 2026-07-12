import con from "./config/db.config.js";

async function testAddAdditionalInfo() {
  try {
    console.log("\n=== Testing addAdditionalInfo logic ===\n");

    // Get valid IDs
    const [employees] = await con.query("SELECT id FROM employee LIMIT 1");
    const employeeId = employees[0].id;
    console.log("Employee ID:", employeeId);

    const [docTypes] = await con.query("SELECT id FROM document_type LIMIT 2");
    const docTypeId1 = docTypes[0].id;
    const docTypeId2 = docTypes[1]?.id || docTypes[0].id;
    console.log("Document type IDs:", docTypeId1, docTypeId2);

    // Simulate the frontend request body
    const documentData = {
      [docTypeId1]: {
        instances: [
          {
            pageNumber: "5",
            file: {
              name: "test-doc-1.pdf",
              url: "http://cloudinary.com/test1.pdf",
              publicId: "test_id_1",
            },
          },
          {
            pageNumber: "10",
            file: {
              name: "test-doc-2.pdf",
              url: "http://cloudinary.com/test2.pdf",
              publicId: "test_id_2",
            },
          },
        ],
      },
      [docTypeId2]: {
        instances: [
          {
            pageNumber: "3",
            file: {
              name: "test-doc-3.pdf",
              url: "http://cloudinary.com/test3.pdf",
              publicId: "test_id_3",
            },
          },
        ],
      },
    };

    console.log("\nDocument Data:", JSON.stringify(documentData, null, 2));

    // Run the same logic as in the controller
    let insertedCount = 0;

    for (const [docTypeId, docInfo] of Object.entries(documentData)) {
      console.log(`\n--- Processing docTypeId: ${docTypeId} ---`);
      const instances = docInfo.instances || [];
      console.log(`Instances: ${instances.length}`);

      if (instances.length === 0) {
        console.log(`No instances for docType ${docTypeId}`);
        continue;
      }

      const [[{ maxIndex }]] = await con.query(
        "SELECT COALESCE(MAX(instance_index), 0) AS maxIndex FROM employee_document WHERE fk_emp_id = ? AND fk_document_type_id = ?",
        [employeeId, docTypeId]
      );
      console.log(`Max index: ${maxIndex}`);

      for (let i = 0; i < instances.length; i++) {
        const instance = instances[i];

        console.log(`\n  Instance ${i}:`, instance);

        if (!instance.file || !instance.file.url) {
          console.log(`  ❌ Skipping - no file`);
          continue;
        }

        const page = parseInt(instance.pageNumber);
        if (!page || isNaN(page)) {
          console.log(`  ❌ Invalid page number`);
          continue;
        }

        const params = [
          employeeId,
          docTypeId,
          maxIndex + i + 1,
          page,
          instance.file.url,
        ];
        console.log(`  ✓ Inserting:`, params);

        const [result] = await con.query(
          "INSERT INTO employee_document (fk_emp_id, fk_document_type_id, instance_index, page_count, cloudinary_url) VALUES (?, ?, ?, ?, ?)",
          params
        );

        console.log(
          `  ✓ Insert result - ID: ${result.insertId}, Affected: ${result.affectedRows}`
        );
        insertedCount++;
      }
    }

    console.log(`\n✓✓✓ Total documents inserted: ${insertedCount} ✓✓✓`);

    // Verify
    const [allRecords] = await con.query(
      "SELECT * FROM employee_document WHERE fk_emp_id = ?",
      [employeeId]
    );
    console.log(
      `\nTotal records in DB for employee ${employeeId}:`,
      allRecords.length
    );
    allRecords.forEach((rec) => {
      console.log(
        `  - ID: ${rec.id}, DocType: ${rec.fk_document_type_id}, Index: ${rec.instance_index}, Pages: ${rec.page_count}`
      );
    });

    // Clean up
    console.log("\n--- Cleaning up test data ---");
    await con.query("DELETE FROM employee_document WHERE fk_emp_id = ?", [
      employeeId,
    ]);
    console.log("✓ Test records deleted");
  } catch (error) {
    console.error("\n❌ Error:", error.message);
    console.error("Stack:", error.stack);
  } finally {
    process.exit(0);
  }
}

testAddAdditionalInfo();
