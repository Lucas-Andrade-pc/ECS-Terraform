variable "region" {
    type = string
    default = "us-east-1"
}

variable "profile" {
    type = string
    default = "aws-lucas"
}

variable "policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}