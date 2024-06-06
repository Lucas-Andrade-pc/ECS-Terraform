data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "ecsRole"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.role.id
  policy_arn = var.policy_arn
}

resource "aws_iam_role_policy_attachment" "ecs_node_role_policy_ECSTask" {
  role       = aws_iam_role.role.name
  policy_arn = var.policy_arn_ECSTask
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "demo-ecs-profile"
  role        = aws_iam_role.role.id
}