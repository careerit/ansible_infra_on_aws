output "bastion_Public_IP" {
    value = aws_instance.bastion.public_ip

}

output "web_IPs" {
    value = aws_instance.web.*.private_ip
}

output "db_IPs" {
    value = aws_instance.db.*.private_ip
}

output "alb_dns" {
    value = aws_lb.myappweb.dns_name 
}