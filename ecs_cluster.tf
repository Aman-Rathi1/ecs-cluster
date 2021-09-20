resource "aws_ecs_cluster" "ecs_cluster" {
  
  name = "${var.clusterName}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}