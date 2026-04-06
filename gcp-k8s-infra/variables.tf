variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  description = "List of zones for the GKE cluster"
  type        = list(string)
}
variable "zone" {
  description = "The zone for the GKE cluster"
  type        = string
}
variable "cluster_name" {
  type = string 
}

variable "machine_type" {
  type = string
}

variable "name" {
  type    = string
}

variable "location" {
  type = string
}

variable "vpc-name" {
  type = string
}

variable "subnet-name" {
  type = string
}
variable "nodes" {
  type = number
}