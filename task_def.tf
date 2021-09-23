resource "aws_ecs_task_definition" "service" {
  family = "vimal13"
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
  task_role_arn = aws_iam_role.ecsTaskExecution_role.arn
  execution_role_arn = aws_iam_role.ecsTaskExecution_role.arn
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "vimal13/apache-webserver-php"
      cpu       = 200
      memory    = 200
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ]
    },
    
  ])
}
