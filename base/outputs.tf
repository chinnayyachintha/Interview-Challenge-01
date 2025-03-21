# Output ECR repository base URL
output "repository_base_url" {
  description = "Base URL for ECR repositories"
  value       = jsonencode(local.ecr_url)
}