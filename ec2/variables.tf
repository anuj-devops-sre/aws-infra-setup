variable "aws_region" {}
variable "vpc_id" {}
variable "public_subnet_1_id" {}
variable "ami_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {}
