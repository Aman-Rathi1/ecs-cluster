## Ecs Task execution role

data "aws_iam_policy_document" "ecs_task-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecsTaskExecution_role" {
  name               = "ecsTaskExecution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task-assume-role-policy.json
}
resource "aws_iam_role_policy" "ecsTaskExecution_policy" {
  name = "ecsTaskExecPolicy"
  role = aws_iam_role.ecsTaskExecution_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("policies/ecsTaskExecutionPolicy.json")
}





#ecs role for Ec2 instance

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsinstance_role" {
  name               = "ecsinstance_role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}
resource "aws_iam_role_policy" "ecspolicy" {
  name = "ecspolicy"
  role = aws_iam_role.ecsinstance_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("policies/ecsInstancePolicy.json")
}
  resource "aws_iam_instance_profile" "ecs_role" {
  name = "ecs_role"
  role = aws_iam_role.ecsinstance_role.name
}


