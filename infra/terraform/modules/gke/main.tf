resource "google_container_cluster" "this" {
  name     = var.name
  location = var.location
  network  = var.network
  subnetwork = var.subnet

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {}

  master_authorized_networks_config {
    cidr_blocks = [{
      cidr_block   = "0.0.0.0/0"
      display_name = "allow-all-demo"
    }]
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
}

resource "google_container_node_pool" "default" {
  name       = "${var.name}-pool"
  cluster    = google_container_cluster.this.name
  location   = var.location
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
