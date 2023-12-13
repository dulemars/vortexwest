variable "name" {
  type    = string
  default = "vortexwest"
}
variable "cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}
variable "aws_region" {
  type    = string
  default = "eu-central-1" 
}

variable "db_engine" {
  type = string
  default = "aurora-postgresql"
}
variable "db_engine_version" {
  type = string
  default = "15.4"
}
variable "db_instance_type" {
  type = string
  default = "db.t3.medium"
}
variable "db_name" {
  type = string
  default = "postgres"
}
variable "db_username" {
  type = string
  default = "postgres"
}
variable "db_pass" {
  type = string
  default = "00000000"
}
variable "db_port" {
  type = string
  default = "5432"
}
