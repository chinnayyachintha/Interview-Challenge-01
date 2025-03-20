module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.interviewee_code}-iam-access"
  path = "/managed/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "iam:AddRoleToInstanceProfile",
              "iam:AttachRolePolicy",
              "iam:CreateInstanceProfile",
              "iam:CreateRole",
              "iam:DetachRolePolicy",
              "iam:GetInstanceProfile",
              "iam:GetRole",
              "iam:ListAttachedRolePolicies",
              "iam:ListInstanceProfilesForRole",
              "iam:ListRolePolicies",
              "iam:RemoveRoleFromInstanceProfile"
          ],
          "Resource": [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.interviewee_code}-news_host",
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/${var.interviewee_code}-news_host"
          ]
      },
      {
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.interviewee_code}-*",
          "Condition": {
              "StringLike": {
                  "iam:PassedToService": [
                      "ec2.amazonaws.com",
                      "ecs-tasks.amazonaws.com"
                  ]
              }
          }
      }
  ]
}
EOF
}


### Explanation

# ✅ Removed DeleteRole and DeleteInstanceProfile – Prevents accidental deletions.
# ✅ Scoped iam:PassRole – Limited role passing to only ${var.interviewee_code}-* roles.
# ✅ Added Condition for PassRole – Restricted to EC2 and ECS services only.
# ✅ Scoped List* Actions – Prevents unnecessary visibility into other roles/policies.

# Why This Matters? 🚀
# More Secure IAM Policy 🛡️
# Prevents Accidental Deletion
# Reduces Risk of Privilege Escalation
# Follows AWS Best Practices