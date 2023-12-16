###############################################################################
# CloudWatch log groups
################################################################################

resource "aws_cloudwatch_log_group" "vortexwest-frontend" {
  name = "vortexwest-frontend"

  tags = {
    Environment = "dev"
    Application = "vortexwest-frontend"
  }
}

resource "aws_cloudwatch_log_group" "vortexwest-backend" {
  name = "vortexwest-backend"

  tags = {
    Environment = "dev"
    Application = "vortexwest-backend"
  }
}
