resource "aws_launch_template" "ecs_lt" {
  name          = "template-ec2"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.type-ec2
  

  key_name               = "ecs"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc.outputs.id_security_ecs}","${data.terraform_remote_state.vpc.outputs.id_security_application}"]
  iam_instance_profile {
    arn = data.terraform_remote_state.role.outputs.profile_arn
  }
  placement {
    availability_zone = var.region
  }
  # network_interfaces {
  #   security_groups = ["${data.terraform_remote_state.vpc.outputs.id_security}", "${data.terraform_remote_state.vpc.outputs.id_security_application}"]
    
  #   associate_public_ip_address = true
  #   subnet_id = data.terraform_remote_state.vpc.outputs.id_subnet[0]
  # }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags

  }
  user_data = "${base64encode(data.template_file.file_data.rendered)}"
}
data "template_file" "file_data" {
  template = file("register-ec2.sh")
}
