data "aws_availability_zones" "region" {}
data "aws_ami" "ubuntu" {
  name_regex = "bionic"
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

