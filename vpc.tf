resource "aws_vpc" "this" {
    cidr_block = var.vpccidr
    instance_tenancy = var.tenancy
    tags = {
      "Name" = "Ecs-Vpc"
    }
  
}

resource "aws_subnet" "private" {
    count = length(var.azs)
    availability_zone = element(var.azs,count.index)
    vpc_id = aws_vpc.this.id
    cidr_block = element(var.prvcidr,count.index)
tags = {
    "Name" = "private-${count.index+1}"
}
  
}
resource "aws_subnet" "public" {
    count = length(var.azs)
    availability_zone = element(var.azs,count.index)
    vpc_id = aws_vpc.this.id
    cidr_block = element(var.pubcidr,count.index)
    map_public_ip_on_launch = true
  
tags = {
  "Name" = "public-${count.index+1}"
}
}


resource "aws_internet_gateway" "gw" {
    depends_on = [
      aws_vpc.this
    ]
    vpc_id = aws_vpc.this.id

tags = {
      "Name" = "Ecs-gw"
    }
}

resource "aws_route_table" "public" {
    depends_on = [
      aws_internet_gateway.gw
    ]
    vpc_id = aws_vpc.this.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}
    
    tags = {
      "Name" = "pub-routes"
    }   
}


resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    tags = {
      "Name" = "private"
    }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public.*.id)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private.*.id)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
  
}


resource "aws_eip" "ecs_eip" {
  vpc = true
}
resource "aws_nat_gateway" "ecs_nat" {
    depends_on = [
      aws_subnet.private
    ]
  allocation_id = aws_eip.ecs_eip.id
  subnet_id = aws_subnet.public.0.id

}

resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.ecs_nat.id
  destination_cidr_block = "0.0.0.0/0"
}
# resource "aws_vpc_endpoint" "ecs" {
#   vpc_id = aws_vpc.this.id
#   vpc_endpoint_type = "Interface"
#   service_name = "com.amazonaws.ap-south-1.ecs"
#   security_group_ids =[ aws_security_group.endpoint_sg.id]
#   subnet_ids = aws_subnet.private.*.id
# }

# resource "aws_vpc_endpoint" "ecs_agent" {
#   vpc_id = aws_vpc.this.id
#   vpc_endpoint_type = "Interface"
#   service_name = "com.amazonaws.ap-south-1.ecs-agent"
#   security_group_ids = [aws_security_group.endpoint_sg.id]
#   subnet_ids = aws_subnet.private.*.id
# }
# resource "aws_vpc_endpoint" "ecs_telemetry" {
#   vpc_id = aws_vpc.this.id
#   vpc_endpoint_type = "Interface"
#   service_name = "com.amazonaws.ap-south-1.ecs-telemetry"
#   security_group_ids = [aws_security_group.endpoint_sg.id]
#   subnet_ids = aws_subnet.private.*.id
# }