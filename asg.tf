###############################################################################
# Autoscaling group
################################################################################

resource "aws_autoscaling_group" "asg" {
 vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
 desired_capacity    = 2
 max_size            = 3
 min_size            = 1
 launch_template {
   id      = aws_launch_template.lt.id
   version = "$Latest"
 }
 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}
