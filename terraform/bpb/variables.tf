# core
variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-north-1"
}

# networking

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-north-1b", "eu-north-1c"]
}

# load balancer

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/ping/"
}


# logs

variable "log_retention_in_days" {
  default = 30
}

# key pairs
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "C:/Users/abalabanov/.ssh/id_rsa.pub"
}

variable "bastion_privkey_file" {
  default = "mykey"
}

variable "bastion_pubkey_file" {
  default = "mykey.pub"
}


# ecs

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "production"
}
variable "amis" {
  description = "Which AMI to spawn."
  default = {
    eu-north-1 = "ami-024910ace68ce0343"
  }
}
variable "instance_type" {
  default = "t3.micro"
}
variable "docker_image_url_django" {
  description = "app docker image to run in the ECS cluster"
  default     = "455385653807.dkr.ecr.eu-north-1.amazonaws.com/bpb:latest"
}
variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 1
}
variable "docker_image_url_nginx" {
  description = "nginx docker image to run in the ECS cluster"
  default     = "455385653807.dkr.ecr.eu-north-1.amazonaws.com/nginx:latest"
}

# auto scaling

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "1"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "1"
}

# rds

variable "rds_db_name" {
  description = "RDS database name"
  default     = "mydb"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "foo"
}
#variable "rds_password" {
#  description = "RDS database password"
#  type = string
#}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}




variable "domain_name" {
  description = "Domain name, linked with loadbalancer (and also used for ALLOWED_HOSTS)"
  default     = "kanavino.ru"
}

# ssl
variable "server_url" {
  type = string
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"  // https://acme-v02.api.letsencrypt.org/directory
}
variable "s3_bucket_name" {
  type = string
  default = "asbbnv-ssl"
}

# s3 to serve static and media files
variable "use_s3" {
  type = string
  default = "TRUE"
}

variable "s3_files_bucket_name" {
  type = string
  default = "bpb-staticfiles"
}
