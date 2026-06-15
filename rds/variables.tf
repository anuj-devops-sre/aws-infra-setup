variable "aws_region" {}
variable "vpc_id" {}
variable "private_subnet_1_id" {}
variable "private_subnet_2_id" {}
variable "app_sg_id" {}
variable "db_instance_class" {
  default = "db.t3.micro"
}
variable "db_allocated_storage" {
  default = 20
}
variable "db_name" {
  default = "appdb"
}
variable "db_username" {}
variable "db_password" {}
