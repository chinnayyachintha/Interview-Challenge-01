output "frontend_url" {
  value = "http://${aws_instance.front_end.public_ip}:8080"
}