resource "google_pubsub_topic" "telemetry" {
  name = var.topic_name
}
resource "google_pubsub_subscription" "telemetry" {
  name                 = var.subscription_name
  topic                = google_pubsub_topic.telemetry.name
  ack_deadline_seconds = 20
  expiration_policy { ttl = "" } # never expire
}
