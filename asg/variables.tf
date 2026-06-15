variable "aws_region" {}
variable "vpc_id" {}
variable "ami_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {}
variable "alb_sg_id" {}
variable "bastion_sg_id" {}
variable "target_group_arn" {}
variable "private_subnet_1_id" {}
variable "private_subnet_2_id" {}
variable "ec2_instance_profile_name" {}
variable "desired_capacity" {
  default = 2
}
variable "min_size" {
  default = 1
}
variable "max_size" {
  default = 4
}
