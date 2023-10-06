resource "aws_instance" "bastion" {
  ami                    = lookup(var.amis, var.region)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]
  associate_public_ip_address = true
  key_name  = aws_key_pair.bastion_key_pair.key_name
  tags = {
    Name = "BPB bastion"
  }
  user_data = <<EOF
ls
EOF
}

# Create a Null Resource and Provisioners to copy key to ec2_bastion_instance
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "keys_to_ec2_bastion_instance" {

  # Connection Block for Provisioners to connect to Bastion Instance
  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("mykey")
  }

  # File Provisioner - copy the aws-terraform-key.pem file to /tmp/aws-terraform-key.pem
  provisioner "file" {
    source      = "mykey"
    destination = "/tmp/mykey"
  }
  ## Remote-Exec Provisioner-  Update the key permissions on Bastion Instance
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/mykey"
    ]
  }
  depends_on = [
    aws_instance.bastion
  ]
}


