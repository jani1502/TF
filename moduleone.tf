##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {AKIA3FXHSH7PKOB24EVA}
variable "aws_secret_key" {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}
variable "private_key_path" {}

variable "key_name" {
  default = "jenkins"
}

variable "instance_type" {
  default = "t2.micro"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "httpd" {
  ami           = "ami-76144b0a"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo service httpd start",
    ]
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
  value = "${aws_instance.httpd.public_dns}"
}
