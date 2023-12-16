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
   },
   {
     name      = "vortexwest-backend"
     image     = "micic/vortexwest:backend"
     cpu       = 512
     memory    = 512
     essential = false
     command   = ["python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
     logConfiguration = {
       logDriver = "awslogs"
       options = {
         awslogs-region = "eu-central-1"
         awslogs-group = "vortexwest-backend"
         awslogs-stream-prefix = "vortexwest-backend"
       }
     }
     portMappings = [
       {
         containerPort = 8000
         hostPort      = 8000
         protocol      = "tcp"
       }
     ]
     environment = [
       {
         name = "POSTGRES_NAME"
         value = "${var.db_name}"
       },
       {
         name = "POSTGRES_USER"
         value = "${var.db_username}"
       },
       {
         name = "POSTGRES_PASSWORD"
         value = "${var.db_pass}"
       },
       {
         name = "POSTGRES_HOST"
         value = "${aws_rds_cluster.rds.endpoint}"
       },
       {
         name = "POSTGRES_PORT"
         value  = "${var.db_port}"
       }
     ]
   }
 ])

 depends_on = [aws_rds_cluster.rds]
}

