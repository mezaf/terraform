provider "aws" {
  profile = "default"
  region = var.region
}
resource "aws_instance" "NiFi-Server" {
  ami = var.ami
  # availability_zone = var.av_zone
  instance_type = var.instance-type
  key_name = var.key
  iam_instance_profile = "EFS-EC2-Admin"
  vpc_security_group_ids =["sg-093a34d82ad88b864",]
  tags = var.tags
}
