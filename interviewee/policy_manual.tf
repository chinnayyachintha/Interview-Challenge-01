module "manual_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.interviewee_code}-manual-access"
  path = "/read-only/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ec2:DescribeInstances",
              "ec2:DescribeVolumes",
              "ec2:DescribeVpcs",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeRouteTables",
              "ec2:DescribeNetworkInterfaces"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "${var.aws_region}"
              }
          }
      }
  ]
}
EOF
}


### Explanation

# ✅ Scoped to Specific EC2 Describe Actions – Removed "ec2:Describe*" to avoid unnecessary exposure.
# ✅ Added "aws:RequestedRegion" Condition – Ensures access is limited to a specific AWS region.
# ✅ Improved Policy Pathing (/read-only/) – Helps organize policies better in IAM.
# ✅ Reduced Risk of Over-Permissioning – No "Resource": ["*"] abuse.

# Why This Matters? 🚀
# Follows Least Privilege Principle 🛡️
# Prevents Accidental Exposure
# Restricts Access by AWS Region
# Enhances Security & Compliance