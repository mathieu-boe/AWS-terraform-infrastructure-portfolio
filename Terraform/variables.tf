variable "aws_region" {
  default     = "eu-west-2"
  description = "AWS region"
}

variable "instance_type" {
  default = "t2.micro"
}

# variable "ssh_cidr" {
#   description = "CIDR block allowed to SSH in"
#   type = string
#   default = "0.0.0.0/0"
# }

variable "public_subnet_cidr" {
    type = string
    description = "Public Subnet CIDR values"
    default = "10.0.1.0/24"
}