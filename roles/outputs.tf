output "role_arn" {
  value = aws_iam_role.role.arn
  sensitive = true
}

output "role_id" {
  value = aws_iam_role.role.id
  sensitive = true
}
output "role_name" {
  value = aws_iam_role.role.name
}
output "profile_arn" {
  value = aws_iam_instance_profile.ecs_node.arn
}