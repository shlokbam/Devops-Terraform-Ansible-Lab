provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

# ---------------- VPC ----------------

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# ---------------- Security Group ----------------

resource "aws_security_group" "websg" {

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# ---------------- EC2 Instance ----------------

resource "aws_instance" "server" {
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t2.micro"
  key_name               = "<YOUR_KEY_PAIR_NAME>"
  subnet_id              = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.websg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("<YOUR_PRIVATE_KEY_NAME>.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
  inline = [
    "sudo apt update -y",
    "sudo apt install python3-pip python3-venv -y",
    "python3 -m venv venv",
    "venv/bin/pip install flask",
    "nohup venv/bin/python /home/ubuntu/app.py > output.log 2>&1 &"
  ]
}
}

# ---------------- Output ----------------

output "public_ip" {
  value = aws_instance.server.public_ip
}