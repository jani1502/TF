##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "key_name" {
  default = "mykey"
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
  region     = "ap-southeast-1"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "httpd" {
  ami           = "ami-0c5199d385b432989"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install apache2 -y",
      "sudo service apache2 start",
    ]
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
  value = "${aws_instance.httpd.public_dns}"
}
output "aws_instance_public_ip" {
  value = "${aws_instance.httpd.public_ip}"
}