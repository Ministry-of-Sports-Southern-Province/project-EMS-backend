import axios from "axios";

async function testBackup() {
  try {
    console.log("Testing backup endpoint for transfer ID: 1");
    const response = await axios.post(
      "http://localhost:3000/api/transfer/requests/1/backup",
    );
    console.log("✅ Backup successful!");
    console.log("Response:", JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.error("❌ Backup failed:");
    console.error("Status:", error.response?.status);
    console.error("Message:", error.response?.data?.message);
    console.error("Error:", error.response?.data?.error);
    console.error("Full error:", error.message);
  }
  process.exit(0);
}

testBackup();
