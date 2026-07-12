import axios from "axios";

async function testApprove() {
  try {
    const response = await axios.put("http://localhost:3000/api/transfer/requests/1/approve", {
      approved_by: "Test User",
      remarks: "Approved for testing"
    });
    console.log("Success:", response.data);
  } catch (error) {
    console.error("Error:", error.response?.data || error.message);
    console.error("Full error:", error.response?.data?.error);
  }
  process.exit(0);
}

testApprove();
