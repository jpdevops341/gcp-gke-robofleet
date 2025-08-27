terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.30" }
  }
}
resource "google_compute_network" "vpc" {
  name                    = var.name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  private_ip_google_access = true
}
resource "google_compute_router" "nat_router" {
  name    = "${var.name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}
resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
