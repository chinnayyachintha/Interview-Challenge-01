# Setup our aws provider
variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "instance_type" {
  type = string
  default = "t3.nano"
}

variable "docker_image_tag" {
  type = string
  default = "latest"
}

variable "prefix" {
  type = string
  default = "newsfeed"
}

