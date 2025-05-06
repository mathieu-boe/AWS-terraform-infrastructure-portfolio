#Expose the public IP for easy SSH access
output "public_ip" {
  description = "Public IP for SSH"
  value = aws_instance.Web.public_ip
}