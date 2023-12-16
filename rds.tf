###############################################################################
# RDS Module
################################################################################

resource "aws_rds_cluster" "rds" {
  cluster_identifier                  = "${var.name}-rds"
  engine                              = var.db_engine
  engine_version                      = var.db_engine_version
  availability_zones                  = ["${var.aws_region}a", "${var.aws_region}b","${var.aws_region}c"] #Has to be 3
  backup_retention_period             = 7
  copy_tags_to_snapshot               = true
  deletion_protection                 = false
  enable_global_write_forwarding      = false
  final_snapshot_identifier           = "${var.name}-final"
  iam_database_authentication_enabled = false
  db_subnet_group_name                = aws_db_subnet_group.this.name
  database_name                       = var.db_name
  master_username                     = var.db_username
  master_password                     = var.db_pass
  skip_final_snapshot                 = true
  storage_encrypted                   = "true"
  vpc_security_group_ids              = [aws_security_group.rds-sg.id]
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count              = 1
  identifier         = "${var.name}-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.id
  instance_class     = var.db_instance_type
  engine             = var.db_engine
  engine_version     = var.db_engine_version
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-${var.name}"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_security_group" "rds-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.name}-RDS-SG"
  ingress {
    protocol    = "tcp"
    from_port   = var.db_port
    to_port     = var.db_port
    cidr_blocks = [var.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "dns_a_record_set" "rds" {
  host = "${aws_rds_cluster.rds.endpoint}"
}
