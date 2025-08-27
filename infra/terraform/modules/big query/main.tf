resource "google_bigquery_dataset" "this" {
  dataset_id                 = var.dataset
  location                   = var.location
  delete_contents_on_destroy = true
}
resource "google_bigquery_table" "telemetry" {
  dataset_id = google_bigquery_dataset.this.dataset_id
  table_id   = "telemetry"
  schema     = file(var.schema_file)

  time_partitioning { type = "HOUR" }
  clustering        = ["robot_id", "event_type"]
}
