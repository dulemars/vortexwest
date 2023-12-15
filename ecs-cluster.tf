###############################################################################
# ECS Module
################################################################################

resource "aws_ecs_cluster" "ecs" {
 name = "ecs-cluster"
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

resource "aws_ecs_task_definition" "ecs_task_definition" {
 family             = "my-ecs-task"
 network_mode       = "awsvpc"
 execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
 cpu                = 256

 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

 container_definitions = jsonencode([
   {
     name      = "vortexwest-frontend"
     image     = "micic/vortexwest:frontend"
     cpu       = 128
     memory    = 256
     essential = true
     logConfiguration = {
       logDriver = "awslogs"
       options = {
         awslogs-region = "eu-central-1"
         awslogs-group = "vortexwest-frontend"
         awslogs-stream-prefix = "vortexwest-frontend"
       }
     }
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
   }
 ])
}
