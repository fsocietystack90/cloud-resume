const API_URL = "https://func-jesusmaria-resume-bch3guetfrdsbnay.eastus-01.azurewebsites.net/api/visitor_count";

async function updateCounter() {
  const counter = document.getElementById("counter");

  try {
    const response = await fetch(API_URL);
    if (!response.ok) {
      throw new Error(`Request failed with status ${response.status}`);
    }
    const data = await response.json();
    counter.textContent = data.count;
  } catch (error) {
    console.error("Could not load the visitor count:", error);
  }
}

updateCounter();