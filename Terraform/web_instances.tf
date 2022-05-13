


resource "aws_network_interface" "web" {
  count = var.webnodes
  subnet_id       = element(aws_subnet.web.*.id, count.index)
  security_groups = [aws_security_group.web.id]
  tags = {
    Name        = "${var.prefix}-web-nic-${count.index}"
    Project     = var.project
    Environment = var.environment
  }

}


resource "aws_instance" "web" {
  count         = var.webnodes
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_node_size
  key_name      = aws_key_pair.mainkey.key_name  
  network_interface {
    network_interface_id = element(aws_network_interface.web.*.id, count.index)
    device_index         = 0
  }

  tags = {
    Name        = "${var.prefix}-web-${count.index}"
    Project     = var.project
    Environment = var.environment
  }
}