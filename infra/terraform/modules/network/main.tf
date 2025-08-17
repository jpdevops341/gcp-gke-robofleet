resource "google_compute_network" "vpc" { name = "robofleet-vpc" auto_create_subnetworks = true }
