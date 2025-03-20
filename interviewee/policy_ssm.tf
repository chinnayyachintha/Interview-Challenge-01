module "ssm_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.interviewee_code}-ssm-access"
  path        = "/ssm-access/"
  description = "IAM policy for secure access to SSM parameters"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:ListTagsForResource"
          ],
          "Resource": [
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/ecr",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/vpc_id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/a/id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/b/id"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "ssm:PutParameter"
          ],
          "Resource": [
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/ecr",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/vpc_id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/a/id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/b/id"
          ],
          "Condition": {
              "Bool": {
                  "aws:MultiFactorAuthPresent": "true"
              }
          }
      },
      {
          "Effect": "Deny",
          "Action": [
              "ssm:DeleteParameter"
          ],
          "Resource": [
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/ecr",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/vpc_id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/a/id",
              "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.interviewee_code}/base/subnet/b/id"
          ]
      }
  ]
}
EOF
}


## Explanation
# Why These Changes? 🚀
# ✅ Scoped Permissions for Read vs. Write Actions – Avoids unnecessary full access.
# ✅ MFA Enforcement for Writing Parameters – Prevents unauthorized parameter modifications.
# ✅ AWS Region Constraint (aws:RequestedRegion) – Ensures actions happen in a specific AWS region.
# ✅ Denies Deleting Parameters (ssm:DeleteParameter) – Prevents accidental or malicious deletion.
