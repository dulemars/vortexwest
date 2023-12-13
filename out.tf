output "vpc" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}
output "vpc_default_sg" {
  description = "VPC default SG ID"
  value       = aws_default_security_group.default.id
}
output "vpc_default_rt" {
  description = "VPC default routing table ID"
  value       = aws_default_route_table.default.id
}
output "subnet1" {
  value = aws_subnet.subnet1.id
}
output "subnet2" {
  value = aws_subnet.subnet2.id
}
output "subnet3" {
  value = aws_subnet.subnet3.id
}
