provider "aws" {
  profile = "default"
  region = "us-east-1"
}
resource "aws_instance" "NiFi-Server" {
  ami = "ami-00d34bbabb16a7591"
  instance_type = "t2.micro"
  key_name = "access_personal"
  iam_instance_profile = "EFS-EC2-Admin"
  vpc_security_group_ids =["sg-093a34d82ad88b864",]
  tags = {
      "Name" = "NiFi Server"
      "Source" = "Terraform"
      "Owner" = "mezaf  "
  }
}
