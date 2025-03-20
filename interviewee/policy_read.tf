module "iam_read_only_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.interviewee_code}-read-only"
  path        = "/read-only/"
  description = "Read-only policy with scoped permissions for EC2 and SSM"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ec2:DescribeInstances",
              "ec2:DescribeVolumes",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeRouteTables",
              "ec2:DescribeSubnets",
              "ec2:DescribeVpcs",
              "ssm:DescribeInstanceInformation",
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:GetParameterHistory"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "${var.aws_region}"
              },
              "Bool": {
                  "aws:MultiFactorAuthPresent": "true"
              }
          }
      }
  ]
}
EOF
}


### Explanation

# ✅ Scoped Actions for Read-Only Permissions – No full ec2 or ssm access.
# ✅ Added "aws:RequestedRegion" Condition – Restricts policy to a specified AWS region.
# ✅ Enforced MFA (aws:MultiFactorAuthPresent) – Ensures users must authenticate securely.
# ✅ Improved Policy Pathing (/read-only/) – Helps with IAM policy organization.
# ✅ Aligned with the Least Privilege Principle – Prevents excessive permissions.

# Why These Changes? 🚀
# Reduces Attack Surface – No unnecessary permissions granted.
# Enhances Compliance & Security 🛡️ – MFA requirement improves access security.
# Restricts to Specific AWS Region – Avoids accidental misconfigurations across regions.
# Optimized for Monitoring & Read-Only Needs – Only necessary EC2 & SSM actions allowed.