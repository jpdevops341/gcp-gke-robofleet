# Runbook: Pub/Sub Backlog
- Confirm subscriber is running and has IAM to pull/ack.
- Check `pubsub_subscription_oldest_unacked_message_age`.
- Increase replicas via KEDA or adjust trigger threshold.