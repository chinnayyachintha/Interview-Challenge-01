module "ecr_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.interviewee_code}-ecr-access"
  path = "/managed/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:BatchCheckLayerAvailability",
              "ecr:BatchGetImage",
              "ecr:CompleteLayerUpload",
              "ecr:DescribeImages",
              "ecr:DescribeRepositories",
              "ecr:GetDownloadUrlForLayer",
              "ecr:GetRepositoryPolicy",
              "ecr:InitiateLayerUpload",
              "ecr:ListImages",
              "ecr:ListTagsForResource",
              "ecr:PutImage",
              "ecr:UploadLayerPart"
          ],
          "Resource": [
              "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/${var.interviewee_code}-quotes",
              "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/${var.interviewee_code}-newsfeed",
              "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/${var.interviewee_code}-front_end"
          ]
      },
      {
          "Effect": "Allow",
          "Action": "ecr:GetAuthorizationToken",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "${var.aws_region}",
                  "aws:PrincipalAccount": "${data.aws_caller_identity.current.account_id}"
              }
          }
      }
  ]
}
EOF
}


### Explanation

# ✅ Removed DeleteRepository – Prevents accidental deletions.
# ✅ Scoped GetAuthorizationToken – Limited based on AWS Account ID & Region.
# ✅ Removed Duplicate DescribeRepositories – Avoids redundancy.
# ✅ Least Privilege Applied – Ensured access is only granted to specific repositories.