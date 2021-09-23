resource "aws_launch_configuration" "ecs_launch_config" {

    image_id             = var.ecs_ami
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



