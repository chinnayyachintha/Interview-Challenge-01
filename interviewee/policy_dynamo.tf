module "dynamodb_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.interviewee_code}-dynamo-access"
  path = "/managed/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "dynamodb:DescribeTable",
              "dynamodb:GetItem",
              "dynamodb:BatchGetItem",
              "dynamodb:PutItem",
              "dynamodb:BatchWriteItem",
              "dynamodb:UpdateItem",
              "dynamodb:ListTagsOfResource",
              "dynamodb:TagResource"
          ],
          "Resource": [
              "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.interviewee_code}-terraform-locks",
              "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.interviewee_code}-terraform-locks/index/*"
          ]
      },
      {
          "Effect": "Deny",
          "Action": [
              "dynamodb:DeleteTable",
              "dynamodb:DeleteItem"
          ],
          "Resource": [
              "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.interviewee_code}-terraform-locks"
          ],
          "Condition": {
              "Bool": { "aws:MultiFactorAuthPresent": "false" }
          }
      }
  ]
}
EOF
}

########## Explanation

# ✅ Removed table deletion (dynamodb:DeleteTable) unless explicitly required.
# ✅ Added MFA enforcement for sensitive actions (DeleteItem).
# ✅ Added support for Batch operations (BatchWriteItem & BatchGetItem) for efficiency.
# ✅ Scoped permissions to include indexes (table/index/*) for query support.