resource "aws_launch_configuration" "ecs_launch_config" {
  depends_on = [
    aws_vpc_endpoint.ecs,
    aws_vpc_endpoint.ecs_agent,
    aws_vpc_endpoint.ecs_telemetry
  ]
  
    image_id             = "ami-0df7a53affdc7cb92"
    iam_instance_profile = aws_iam_instance_profile.ecs_role.name
    security_groups      = [aws_security_group.ecs_ec2_sg.id]
    user_data            = templatefile("userdata.sh",
    {
      clustername = var.clusterName
      region      = var.region
    })
    instance_type        = "t2.micro"
    key_name             = var.key_name
}


#ami-0a23ccb2cdd9286bb
