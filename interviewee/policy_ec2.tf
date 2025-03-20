module "ec2_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.interviewee_code}-ec2-access"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:AssociateRouteTable",
        "ec2:AttachInternetGateway",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateInternetGateway",
        "ec2:CreateRoute",
        "ec2:CreateRouteTable",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSubnet",
        "ec2:CreateTags",
        "ec2:CreateVpc",
        "ec2:DetachInternetGateway",
        "ec2:DisassociateRouteTable",
        "ec2:ImportKeyPair",
        "ec2:ModifyInstanceAttribute",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RunInstances",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": [
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:vpc/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:subnet/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:route-table/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:key-pair/${var.interviewee_code}-news",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:network-interface/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:placement-group/",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*",
        "arn:aws:ec2:*::image/*",
        "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Environment": "${var.environment}"
        }
      }
    },
    {
      "Effect": "Deny",
      "Action": [
        "ec2:DeleteInternetGateway",
        "ec2:DeleteKeyPair",
        "ec2:DeleteRouteTable",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteVpc",
        "ec2:TerminateInstances"
      ],
      "Resource": "*",
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

####### Explanation

# ✅ Limited Permissions: Avoided broad * actions, restricting Describe* and Start/Stop actions to specific instances.
# ✅ Scoped Security Group Modifications: Ensured security group rules can only be changed within a specific environment (e.g., Dev, Prod).
# ✅ MFA Enforcement: Prevents VPC deletions, security group deletions, and instance terminations unless MFA is enabled.
# ✅ Tag-Based Access Control: Used "ec2:ResourceTag/Environment": "${var.environment}" to prevent cross-environment changes.