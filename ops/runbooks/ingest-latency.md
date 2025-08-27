# Runbook: Ingest Latency Breach
1) Check Pub/Sub backlog & ack age.
2) Verify KEDA ScaledObject and current replica count.
3) Inspect ingestor CPU/memory; adjust HPA/KEDA thresholds.
4) Check BigQuery insert quota/errors.
5) If a rollout just happened, consider rollback via Argo Rollouts.