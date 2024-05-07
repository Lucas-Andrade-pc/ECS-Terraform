output "auto-scaling-id" {
  value = aws_autoscaling_group.ecs_asg.id
}

output "auto-scaling-arn" {
  value = aws_autoscaling_group.ecs_asg.arn
}
