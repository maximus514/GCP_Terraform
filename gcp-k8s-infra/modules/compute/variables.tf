variable "cluster_name" {
  type = string
}
variable "zone" {
  type = string
}
variable "machine_type" {
  type = string
}
variable "network_self_link" {
  type = string
}
variable "subnet_self_link" {
  type = string
}
variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "nodes" {
  type = string
}
variable "zones" {
  type = list(string)
}