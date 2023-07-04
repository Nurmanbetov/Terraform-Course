# Block-1: Terraform Setting Block

terraform {
    required_version = "~> 0.14"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
      }
    }
    backend "s3" {
        bucket = "terraform-stacksimplify"
        key    = "dev2/terraform.tfstate"
        region = "us-east-1"

        dynamodb_table = "terraform-dev-state-table"
    }
} 

# Block-2: Provider Block
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

#Block-3: Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-"
  instance_type = var.instance_type
}

#Block-4: Input Variables Block
variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance Type"
  type = string
}

#Block-5: Output Values Block
output "ec2_instance_public" {
  description = "EC2 Instance Public IP"
  value = aws_instance.my-ec2-vm.public_ip
}

#Block-6: Local Values Block
#Create S3 Bucket - with input Variables & Local Values
locals {
  bucket-name-prefix = "${var.app_name}-${var.environment_name}"
}

#Block-7: Data sources Block
#Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

#Block-8: Modules Block
#AWS EC2 Instance Module

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "my-modules-demo"
  instance_count = 2

  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  key_name = "terraform-key"
  monitoring = true
  vpc_security_group_ids = ["sg-"]
  subnet_id = "subnet-"
  user_data = file("apache-install.sh")

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}