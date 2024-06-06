resource "aws_launch_template" "ecs_lt" {
  name          = "template-ec2"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.type-ec2


  key_name               = "ecs"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc.outputs.id_security_application}", "${data.terraform_remote_state.vpc.outputs.id_security}"]
  iam_instance_profile {
    arn = data.terraform_remote_state.role.outputs.profile_arn
  }
  placement {
    availability_zone = var.region
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags

  }
  user_data = "${file("register-ec2.sh")}"
}
data "template_file" "file_data" {
  template = file("register-ec2.sh")
}
