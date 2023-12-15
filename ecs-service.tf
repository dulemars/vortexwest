###############################################################################
# ECS service definition
################################################################################

resource "aws_ecs_service" "vortexwest" {
 name            = "vortexwest"
 cluster         = aws_ecs_cluster.ecs.id
 task_definition = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count   = 2

 network_configuration {
   subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
   security_groups = [aws_default_security_group.default.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 triggers = {
   redeployment = timestamp()
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.tg.arn
   container_name   = "vortexwest-frontend"
   container_port   = 80
 }

 depends_on = [aws_autoscaling_group.asg]
}
