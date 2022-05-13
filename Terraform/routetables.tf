resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.myapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "${var.prefix}-publicrt"

  }
}
resource "aws_route_table_association" "pubsubnets" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.pubroute.id
}

resource "aws_route_table" "prvroute" {
  vpc_id = aws_vpc.myapp.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.mynatgw.id
  }

  tags = {
    Name = "${var.prefix}-privatert"

  }
}


resource "aws_route_table_association" "websubnets" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.web.*.id, count.index)
  route_table_id = aws_route_table.prvroute.id
}



resource "aws_route_table_association" "dbsubnets" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.db.*.id, count.index)
  route_table_id = aws_route_table.prvroute.id
}