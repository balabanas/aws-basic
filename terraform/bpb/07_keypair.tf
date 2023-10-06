resource "aws_key_pair" "production" {
  key_name   = "${var.ecs_cluster_name}_key_pair"
  public_key = file(var.ssh_pubkey_file)
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion_key_pair"
  public_key = file(var.bastion_pubkey_file)
}