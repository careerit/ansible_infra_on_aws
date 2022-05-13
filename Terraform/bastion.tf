data "template_file" "ansible_user_data" {
  template = file("${path.module}/Templates/ansible_cloudinit.tpl")

}

resource "aws_network_interface" "bastion" {
  subnet_id       = aws_subnet.public[1].id
  security_groups = [aws_security_group.bastion.id]
  
  tags = {
    Name        = "${var.prefix}-bastion-nic"
    Project     = var.project
    Environment = var.environment
  }

}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_size
  key_name        = aws_key_pair.mainkey.key_name 
  user_data     = base64encode(data.template_file.ansible_user_data.rendered)
  # user_data_replace_on_change = true
  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  tags = {
    Name        = "${var.prefix}-bastion"
    Project     = var.project
    Environment = var.environment
  }
}
