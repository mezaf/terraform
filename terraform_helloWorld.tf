provider "aws" {
  region = var.region
}

resource "tls_private_key" "tmp" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "user-ssh-key" {
  key_name   = "my-efs-mount-key"
  public_key = tls_private_key.tmp.public_key_openssh
}

resource "aws_instance" "NiFi-Server" {
  ami = var.ami
  # availability_zone = var.av_zone
  instance_type = var.instance-type
  key_name = aws_key_pair.user-ssh-key.key_name
  iam_instance_profile = "EFS-EC2-Admin"
  vpc_security_group_ids =["sg-093a34d82ad88b864",]
  subnet_id = "subnet-6116485f"
  tags = var.tags
  provisioner "remote-exec" {
    inline = [
    "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-cbe6f64b.efs.us-east-1.amazonaws.com:/efs",
    "sudo /opt/nifi/nifi-1.11.4/bin/nifi.sh start",
    "sudo /opt/nifi/nifi-1.11.4/bin/nifi.sh status",
  ]
  }
  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.tmp.private_key_pem
  }
}

# output "private_key" {
#   value = tls_private_key.tmp.private_key_pem
# }

# output "ec2_ip" {
#   value = aws_instance.NiFi-Server.public_ip
# }