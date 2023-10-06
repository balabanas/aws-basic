resource "aws_instance" "bastion" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]

  key_name = aws_key_pair.mykeypair.key_name
  user_data = "#!/bin/bash\necho ECS_CLUSTER='b-cluster' > /etc/ecs/ecs.config\necho DDS=true >> /etc/ecs/ecs.config"
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


resource "aws_instance" "private" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]
  key_name = aws_key_pair.mykeypair.key_name
}