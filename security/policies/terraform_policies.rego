package terraform.security

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_container_cluster"
  resource.change.after.master_authorized_networks_config == null
  msg = "GKE cluster must enable master authorized networks"
}