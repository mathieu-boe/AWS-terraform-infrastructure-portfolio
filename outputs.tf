output "public_ip" {
  value = aws_eip.web_eip.public_ip
}

output "private_ip" {
  value = aws_network_interface.web_nic.private_ip
}

output "instance_id" {
  value = aws_instance.web.id
}