resource "aws_security_group" "lb_security_group" {
  name   = "lb-security-group"
  vpc_id = data.terraform_remote_state.vpc.outputs.id_vpc

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "lb_ecs" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets = ["${data.terraform_remote_state.vpc.outputs.id_subnet[0]}", "${data.terraform_remote_state.vpc.outputs.id_subnet[1]}"]

  tags = local.common_tags
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id_vpc

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.lb_ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}