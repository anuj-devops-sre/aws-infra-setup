output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_db_name" {
  value = aws_db_instance.mysql.db_name
}
