# IAM User Module
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.33.1"

  name          = "interview-${var.interviewee_code}"
  force_destroy = false # Prevents accidental deletions in production

  password_reset_required = true # Ensures password reset at first login
}

# IAM Group for Interview Users
resource "aws_iam_group" "interview_group" {
  name = "interview-users"
}

# Attach Policies to Group (Least Privilege Principle)
resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each = {
    "dynamodb"      = module.dynamodb_policy.arn
    "ec2"           = module.ec2_policy.arn
    "ecr"           = module.ecr_policy.arn
    "iam"           = module.iam_policy.arn
    "iam_read_only" = module.iam_read_only_policy.arn
    "manual"        = module.manual_policy.arn
    "s3"            = module.s3_policy.arn
    "ssm"           = module.ssm_policy.arn
  }
  group      = aws_iam_group.interview_group.name
  policy_arn = each.value
}

# Enforce MFA for Security
resource "aws_iam_policy" "mfa_enforce" {
  name        = "EnforceMFA"
  description = "Requires MFA for IAM user actions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          Bool = { "aws:MultiFactorAuthPresent" = "false" }
        }
      }
    ]
  })
}

# Attach MFA Policy to Group
resource "aws_iam_group_policy_attachment" "mfa_group_policy" {
  group      = aws_iam_group.interview_group.name
  policy_arn = aws_iam_policy.mfa_enforce.arn
}

# Assign User to Interview Group
resource "aws_iam_user_group_membership" "add_user_to_group" {
  user   = module.iam_user.iam_user_name # Updated to correct output
  groups = [aws_iam_group.interview_group.name]
}

##### Explanation
# Improvements Made
# ✅ Uses IAM Groups instead of attaching policies to individual users.
# ✅ Enforces Multi-Factor Authentication (MFA) for security.
# ✅ Prevents accidental deletion (force_destroy = false).
# ✅ Ensures password reset at first login (password_reset_required = true).
# ✅ Manages access permissions with least privilege approach.