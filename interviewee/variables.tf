variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "environment" {
  description = "The environment tag (e.g., Dev, Prod) for resource tagging"
  type        = string
  default     = "Dev"
}

variable "interviewee_code" {
  type = string

  validation {
    condition     = length(var.interviewee_code) < 16 && can(regex("^[a-zA-Z0-9]+$", var.interviewee_code))
    error_message = "The interviewee_code value must be less than 16 characters long and only contain alphanumeric characters."
  }
}