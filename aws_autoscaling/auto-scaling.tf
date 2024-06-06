resource "aws_autoscaling_group" "ecs_asg" {
  name = "auto-scaling-cluster-ecs"
  # count = length(data.terraform_remote_state.vpc.outputs.id_subnet)
  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.outputs.id_subnet[1]}","${data.terraform_remote_state.vpc.outputs.id_subnet[2]}"]
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = data.terraform_remote_state.template.outputs.template-id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}