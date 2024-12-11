terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Change this to your preferred region
}

resource "aws_lightsail_instance" "test_instance" {
  name              = "test-instance"
  availability_zone = "us-west-2a"  # Change this to match your region
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"    # Smallest instance type (1 vCPU, 512MB RAM)

  tags = {
    Environment = "testing"
  }
}

# Optional: Create a static IP
resource "aws_lightsail_static_ip" "test_static_ip" {
  name = "test-static-ip"
}

# Attach static IP to instance
resource "aws_lightsail_static_ip_attachment" "test_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.test_static_ip.name
  instance_name  = aws_lightsail_instance.test_instance.name
}

output "instance_ip" {
  value = aws_lightsail_static_ip.test_static_ip.ip_address
}

output "instance_username" {
  value = "ec2-user"  # Default username for Amazon Linux 2
}