data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "mainkey" {
  template = file(var.public_key_path)

}

resource "aws_key_pair" "mainkey" {
    key_name = "mycloudopskey"
    public_key = data.template_file.mainkey.rendered 

}
