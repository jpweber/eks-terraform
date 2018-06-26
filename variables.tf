#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "vpc-cidr-block" {
  type        = "string"
  description = "CIDR blocks for vpc"
  default     = "10.0.0.0/16"
}

variable "public-subnet-blocks" {
  type        = "map"
  description = "CIDR blocks for each public subnet of vpc"

  default = {
    "0" = "10.0.0.0/24"
    "1" = "10.0.1.0/24"
    "2" = "10.0.2.0/24"
  }
}

variable "private-subnet-blocks" {
  type        = "map"
  description = "CIDR blocks for each private subnet of vpc"

  default = {
    "0" = "10.0.10.0/24"
    "1" = "10.0.11.0/24"
    "2" = "10.0.12.0/24"
  }
}

variable "num-public-subnets" {
  default = 3
}

variable "num-private-subnets" {
  default = 3
}

variable "ami_id" {
  type = "string"
}

variable "ssh_public_key_name" {
  type        = "string"
  description = "The key name - will be computed based on stage name if left empty"
  default     = ""
}

variable "ssh_public_key_file" {
  type        = "string"
  description = "The public key file location - will be computed based on stage name if left empty"
  default     = ""
}
