module "s3_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.interviewee_code}-s3-access"
  path        = "/s3-access/"
  description = "IAM policy for secure S3 bucket access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket",
              "s3:GetBucketLocation",
              "s3:GetBucketAcl",
              "s3:GetBucketPolicy",
              "s3:GetBucketVersioning",
              "s3:GetBucketPublicAccessBlock",
              "s3:GetLifecycleConfiguration"
          ],
          "Resource": [
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra",
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra-static-pages"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:GetObject",
              "s3:PutObject",
              "s3:DeleteObject"
          ],
          "Resource": [
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra/*",
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra-static-pages/*"
          ],
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "${var.aws_region}"
              },
              "Bool": {
                  "aws:MultiFactorAuthPresent": "true"
              }
          }
      },
      {
          "Effect": "Deny",
          "Action": [
              "s3:DeleteBucket",
              "s3:PutBucketPolicy"
          ],
          "Resource": [
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra",
              "arn:aws:s3:::${var.interviewee_code}-terraform-infra-static-pages"
          ],
          "Condition": {
              "Bool": {
                  "aws:MultiFactorAuthPresent": "false"
              }
          }
      }
  ]
}
EOF
}

### Explanation

# Why These Changes? 🚀
# ✅ Scoped Permissions for Buckets vs. Objects – Avoided unnecessary full bucket access.
# ✅ MFA Enforcement for Sensitive Actions – Prevents unauthorized deletions or updates.
# ✅ Restricted Bucket Deletion & Policy Updates – Avoids accidental security risks.
# ✅ AWS Region Condition (aws:RequestedRegion) – Ensures actions happen in a specified region.
# ✅ Prevents Accidental Full Bucket Wipe – "s3:DeleteBucket" and "s3:PutBucketPolicy" denied if MFA isn't used.