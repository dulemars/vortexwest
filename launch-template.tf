###############################################################################
# Launch template for ECS
################################################################################

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_launch_template" "lt" {
 name_prefix   = "ecs-template"
 image_id      = data.aws_ami.ecs.image_id
 instance_type = "t3.micro" ## template this
 key_name               = "dulemars"
 vpc_security_group_ids = [aws_default_security_group.default.id]
 iam_instance_profile {
   name = "ecsInstanceRole"
 }
 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp2"
   }
 }

 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "ecs-instance"
   }
 }
 user_data = filebase64("./ecs.sh")
}
