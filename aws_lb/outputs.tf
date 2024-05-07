output "lb_arn" {
  value = aws_lb.lb_ecs.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}