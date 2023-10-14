variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Define the number of subnets and their names
variable "subnet_count" {
  default = 3
}

variable "subnet_names" {
  default = ["subnet-1", "subnet-2", "subnet-3"]
}