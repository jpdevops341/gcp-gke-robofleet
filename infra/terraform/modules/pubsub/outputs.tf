output "topic"        { value = google_pubsub_topic.telemetry.name }
output "subscription" { value = google_pubsub_subscription.telemetry.name }
