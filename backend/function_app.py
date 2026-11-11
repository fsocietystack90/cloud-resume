import json
import os

import azure.functions as func
from azure.cosmos import CosmosClient
from azure.identity import DefaultAzureCredential

# Connect to Cosmos DB once, when the app starts
credential = DefaultAzureCredential()
client = CosmosClient(os.environ["COSMOS_ENDPOINT"], credential=credential)
container = client.get_database_client("resume-db").get_container_client("counter")

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="visitor_count", methods=["GET"])
def visitor_count(req: func.HttpRequest) -> func.HttpResponse:
    # Add 1 to the count and get the updated item back
    item = container.patch_item(
        item="1",
        partition_key="1",
        patch_operations=[{"op": "incr", "path": "/count", "value": 1}],
    )

    # Send the new count back as JSON
    return func.HttpResponse(
        json.dumps({"count": item["count"]}),
        mimetype="application/json",
    )