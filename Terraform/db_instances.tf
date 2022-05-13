resource "aws_network_interface" "db" {
  count = var.dbnodes
  subnet_id       = element(aws_subnet.db.*.id, count.index)
  security_groups = [aws_security_group.db.id]
  tags = {
    Name        = "${var.prefix}-db-nic-${count.index}"
    Project     = var.project
    Environment = var.environment
  }

}


resource "aws_instance" "db" {
  count         = var.dbnodes
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.db_node_size
  key_name      = aws_key_pair.mainkey.key_name
  
  network_interface {
    network_interface_id = element(aws_network_interface.db.*.id, count.index)
    device_index         = 0
  }

  tags = {
    Name        = "${var.prefix}-db-${count.index}"
    Project     = var.project
    Environment = var.environment
  }
}