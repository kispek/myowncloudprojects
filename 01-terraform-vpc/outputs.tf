output "jump_host_public_ip" {
  description = "Publiczny adres IP do łączenia się z Jump Hostem"
  value       = aws_instance.jump_host.public_ip
}

output "private_server_ip" {
  description = "Prywatny adres IP serwera docelowego"
  value       = aws_instance.private_server.private_ip
}

output "vpc_id" {
  description = "ID nowo utworzonej VPC"
  value       = aws_vpc.main.id
}
