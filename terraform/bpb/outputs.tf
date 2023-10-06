output "alb_hostname" {
  value = aws_lb.production.dns_name
}

output "bastion_hostname" {
  value = aws_instance.bastion.public_ip
}