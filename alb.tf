###############################################################################
# ALB Module
################################################################################

resource "aws_lb" "alb" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb.id]
 subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
}

resource "aws_lb_listener" "alb_listener" {
 load_balancer_arn = aws_lb.alb.arn
 port              = 80
 protocol          = "HTTP"
 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.tg.arn
 }
}

resource "aws_lb_target_group" "tg" {
 name        = "vortexwest-tg"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.vpc.id
 health_check {
   path = "/"
 }
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.name}-alb-sg"
  ingress {
    protocol    = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.cidr_block]
  }
}
