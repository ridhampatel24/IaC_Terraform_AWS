variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_for_server" {}
variable "enable_public_ip_address" {}
variable "user_data_install_server" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/ridham/.ssh/id_rsa ubuntu@", aws_instance.server_ec2_instance_ip.public_ip)
}

output "server_ec2_instance_ip" {
  value = aws_instance.server_ec2_instance_ip.id
}

output "dev_proj_1_ec2_instance_public_ip" {
  value = aws_instance.server_ec2_instance_ip.public_ip
}

resource "aws_instance" "server_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_ec2_terraform"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_for_server
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_server

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "server_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"
  public_key = var.public_key
}
