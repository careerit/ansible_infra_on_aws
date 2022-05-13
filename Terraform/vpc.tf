resource "aws_vpc" "myapp" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.prefix}-vpc"
    Project     = var.project
    Environment = var.environment
  }

}



resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.myapp.id
  cidr_block              = element(var.pubsubnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.prefix}-pubsubnet-${count.index}"
    Project     = var.project
    Environment = var.environment
  }

}

resource "aws_subnet" "web" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.myapp.id
  cidr_block        = element(var.websubnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name        = "${var.prefix}-websubnet-${count.index}"
    Project     = var.project
    Environment = var.environment
  }

}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myapp.id

  tags = {
    Name        = "${var.prefix}-igw"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_eip" "myeip" {
  vpc = true
  tags = {
    Name        = "${var.prefix}-nat-eip"
    Project     = var.project
    Environment = var.environment
  }

}


resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.prefix}-natgw"
    Project     = var.project
    Environment = var.environment
  }
}




resource "aws_subnet" "db" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.myapp.id
  cidr_block        = element(var.dbsubnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name        = "${var.prefix}-dbsubnet-${count.index}"
    Project     = var.project
    Environment = var.environment
  }

}


