###############################################################################
# ECS Module
################################################################################

resource "aws_ecs_cluster" "ecs" {
 name = "ecs-cluster"
 setting {
   name  = "containerInsights"
   value = "enabled"
 }
 configuration {
   execute_command_configuration {
     logging    = "OVERRIDE"
     log_configuration {
       cloud_watch_log_group_name = aws_cloudwatch_log_group.vortexwest.name
     }
   }
 }
}

resource "aws_ecs_capacity_provider" "ecs_cp" {
 name = "vortexwest"
 auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.asg.arn
   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 2
   }
 }
}

resource "aws_ecs_cluster_capacity_providers" "ecs-cluster" {
 cluster_name = aws_ecs_cluster.ecs.name
 capacity_providers = [aws_ecs_capacity_provider.ecs_cp.name]
 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
 }
}

resource "aws_cloudwatch_log_group" "vortexwest" {
  name = "vortexwest"
}
