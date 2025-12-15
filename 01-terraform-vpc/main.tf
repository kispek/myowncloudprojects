
provider "aws" {
  region = var.aws_region #polecenie pracy z aws 
}
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-VPC"
  }
} #utworzenie głównej sieci vpc 

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true #WAŻNE bo instancje w tej podsieci daja publiczne ip
  tags = {
    Name = "${var.project_name}-Public-A"
  }
} # tutaj tworzenie jest publicznej podsieci ktora moze miec dostep do internetu 

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.project_name}-Private-A"
  }
}

# internet gateway czyli IGW - Zapewnia dostęp do/z Internetu dla VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-IGW"
  }
}

#  Elastic IP czyli stały publiczny IP dla NAT gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "${var.project_name}-EIP-NAT"
  }
}

#  NAT Gateway - Umożliwia ruch WYCHODZĄCY dla podsieci PRYWATNEJ
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  # NAT GW musi znajdować się w podsieci PUBLICZNEJ!
  subnet_id = aws_subnet.public_a.id
  tags = {
    Name = "${var.project_name}-NAT-GW"
  }
}

# tabela routingu publicznego (cały ruch do IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" # Cały ruch
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.project_name}-Public-RT"
  }
}

# tabela routingu prywatnego (Cały ruch do NAT GW)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.project_name}-Private-RT"
  }
}

# powiązanie tablic z podsieciami
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "ssh_access" {
  vpc_id = aws_vpc.main.id

  # Ruch Przychodzący Ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ruch Wychodzący Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-SSH-SG"
  }
}

resource "aws_instance" "jump_host" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public_a.id
  security_groups = [aws_security_group.ssh_access.id]
  key_name        = var.key_pair_name
  tags = {
    Name = "${var.project_name}-Jump-Host"
  }

} # jumphost - instancja w podsieci publicznej


resource "aws_instance" "private_server" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.private_a.id
  security_groups = [aws_security_group.ssh_access.id]
  key_name        = var.key_pair_name
  tags = {
    Name = "${var.project_name}-Private-server"
  }

} # prywatny serwer - instancja w podsieci prywatnej 





