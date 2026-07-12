import axios from "axios";

async function testEndpoint() {
  try {
    const response = await axios.get("http://localhost:3000/api/transfer/requests");
    console.log("Success:", response.data);
  } catch (error) {
    console.error("Error:", error.response?.data || error.message);
  }
  process.exit(0);
}

testEndpoint();
