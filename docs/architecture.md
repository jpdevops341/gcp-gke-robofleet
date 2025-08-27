# Architecture Notes
- Private VPC + NAT; control plane authorized networks.
- Workload Identity binds KSA↔GSA; Secret Manager CSI for secrets.
- Pub/Sub topic/subscription for telemetry; BigQuery dataset partitioned hourly, clustered by robot_id/event_type.
- KEDA scales based on Pub/Sub subscription metrics; Argo Rollouts for canary.
