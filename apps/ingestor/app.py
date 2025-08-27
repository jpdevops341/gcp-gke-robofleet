from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import os, json
from google.cloud import pubsub_v1, bigquery, storage

app = FastAPI(title="robofleet-ingestor")

PROJECT = os.getenv("GCP_PROJECT") or os.getenv("GOOGLE_CLOUD_PROJECT")
BQ_DATASET = os.getenv("BQ_DATASET", "robofleet")
BQ_TABLE = os.getenv("BQ_TABLE", "telemetry")
GCS_BUCKET = os.getenv("GCS_BUCKET", "")
SUBSCRIPTION = os.getenv("PUBSUB_SUBSCRIPTION", "robofleet-telemetry-sub")

_bq = None
_gcs = None

class Telemetry(BaseModel):
    ts: float = Field(..., description="epoch seconds")
    robot_id: str
    event_type: str
    lat: float | None = None
    lng: float | None = None
    battery: float | None = None
    payload: dict | None = None

@app.get("/health")
def health():
    return {"status": "ok"}

def _bq_client():
    global _bq
    if not _bq: _bq = bigquery.Client(project=PROJECT)
    return _bq

def _gcs_client():
    global _gcs
    if not _gcs and GCS_BUCKET:
        _gcs = storage.Client(project=PROJECT)
    return _gcs

@app.post("/ingest")
def ingest(item: Telemetry):
    row = {
        "ts": item.ts,
        "robot_id": item.robot_id,
        "event_type": item.event_type,
        "lat": item.lat,
        "lng": item.lng,
        "battery": item.battery,
        "payload": json.dumps(item.payload or {})
    }
    table = f"{PROJECT}.{BQ_DATASET}.{BQ_TABLE}"
    errors = _bq_client().insert_rows_json(table, [row])
    if errors:
        raise HTTPException(status_code=500, detail=str(errors))
    if GCS_BUCKET:
        blob_name = f"telemetry/{int(item.ts)}/{item.robot_id}.json"
        bucket = _gcs_client().bucket(GCS_BUCKET)
        bucket.blob(blob_name).upload_from_string(json.dumps(row))
    return {"ingested": 1}