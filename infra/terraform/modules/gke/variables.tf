variable "name"        { type = string }
variable "location"    { type = string }
variable "network"     { type = string }
variable "subnet"      { type = string }
variable "project"     { type = string }
variable "machine_type" { type = string  default = "e2-standard-4" }
variable "node_count"   { type = number  default = 2 }
