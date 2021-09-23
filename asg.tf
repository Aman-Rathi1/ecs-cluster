
resource "aws_autoscaling_group" "ecs_sg" {
    depends_on = [
      aws_lb.ecs_lb
    ]
    name                      = "asg"
    vpc_zone_identifier       = aws_subnet.private.*.id
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = var.desired_capacity_asg
    min_size                  = var.min_size_asg
    max_size                  = var.max_size_asg
    health_check_grace_period = 150
    health_check_type         = "EC2"
    
}