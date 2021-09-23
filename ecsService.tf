resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.count_container
  iam_role          = var.service_arn
  load_balancer {
      target_group_arn = aws_lb_target_group.autoscaleTG.arn
      container_name = "first"
      container_port = 80
  }
}

