provider "aws" {
  region = var.region
}

# Fetch latest Ubuntu 24.04 AMI for ap-south-1
#data "aws_ami" "ubuntu" {
#  most_recent = true
#  owners      = ["099720109477"]
#
#  filter {
#    name   = "image-id"
#    values = ["ami-0f918f7e67a3323f0 "]  # Ubuntu 22.04 LTS (x86_64) in ap-south-1
#  }
#Amazon Machine Image (AMI)

#  filter {
#    name   = "architecture"
#    values = ["x86_64"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#}

resource "aws_security_group" "kafka_sg_broker" {
  name        = "kafka-kraft-sg-broker"
  description = "Kafka KRaft ports for broker & consumer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
  }
  

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  ingress{
    from_port   = 9097
    to_port     = 9097 # for broker - consumer connection
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  ingress {
    from_port   = 7071 # for prometheus 
    to_port     = 7071
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kafka_sg_consumer"{
  name = "kafka-grafana-sg"
  description = "Kafka kraft ports for consumer & grafana or prometheus"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict in production
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  ingress {
    from_port   = 9097 # for broker - consumer connection
    to_port     = 9097
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  ingress {
    from_port   = 7071 # for prometheus 
    to_port     = 7071
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your VPC CIDR
  }
}

resource "aws_instance" "kafka_node" {
  count         = var.broker_count
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids_broker, count.index % length(var.subnet_ids_broker))
  key_name      = var.key_names
  security_groups = [aws_security_group.kafka_sg_broker.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 75
  }

  tags = {
    Name = "kafka-kraft-node-${count.index + 1}"
  }

}

resource "aws_instance" "kafka_consumer_monitoring" {
  count         = 1
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3a.medium"
  subnet_id     = var.subnet_ids_consumer
  key_name      = var.key_names
  security_groups = [aws_security_group.kafka_sg_consumer.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 75
  }

  tags = {
    Name = "kafka-consumer-and-Grafana"
  }
}