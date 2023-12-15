###############################################################################
# ECS task definitions
################################################################################

resource "aws_ecs_task_definition" "ecs_task_definition" {
 family             = "my-ecs-task"
 network_mode       = "awsvpc"
 execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
 cpu                = 1024

 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

 container_definitions = jsonencode([
   {
     name      = "vortexwest-frontend"
     image     = "micic/vortexwest:frontend"
     cpu       = 512
     memory    = 512
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

