terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.30" }
  }
}
provider "google" {
  project = var.project
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "robofleet"
  cidr   = "10.30.0.0/16"
  region = var.region
}

module "gke" {
  source   = "../../modules/gke"
  name     = "robofleet-gke"
  location = var.region
  network  = module.vpc.network
  subnet   = module.vpc.subnet
  project  = var.project
}

module "pubsub" {
  source            = "../../modules/pubsub"
  topic_name        = "robofleet-telemetry"
  subscription_name = "robofleet-telemetry-sub"
}

module "bigquery" {
  source      = "../../modules/bigquery"
  dataset     = "robofleet"
  location    = var.region
  schema_file = "${path.module}/schema.telemetry.json"
}

output "cluster_name" { value = module.gke.cluster_name }
output "topic"        { value = module.pubsub.topic }
output "subscription" { value = module.pubsub.subscription }
output "bq_dataset"   { value = module.bigquery.dataset_id }