# IAM policy document for EC2 instance role assumption
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for EC2 instance
resource "aws_iam_role" "news_host" {
  name               = "${var.prefix}-news-host"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# Fetch Amazon ECR ReadOnly policy
data "aws_iam_policy" "ecr_readonly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

# Attach Amazon ECR ReadOnly policy to the IAM role
resource "aws_iam_role_policy_attachment" "ecr_read_attach" {
  role       = aws_iam_role.news_host.name
  policy_arn = data.aws_iam_policy.ecr_readonly.arn
}

# IAM Instance Profile for EC2 instances
resource "aws_iam_instance_profile" "news_host" {
  name = "${var.prefix}-news-host"
  role = aws_iam_role.news_host.name
}
