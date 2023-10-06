variable "AWS_REGION" {
  default = "eu-north-1"
}

variable "PRIVATE_KEY" {
  default = "mykey"
}

variable "PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-north-1 = "ami-071df4a41c6f9ee2e"
  }
}