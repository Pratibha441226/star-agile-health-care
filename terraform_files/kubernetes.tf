provider "aws" {
region = "ap-south-1"
}
resource "aws_instance" "kubernetes-server" {
ami =""
instance_type = "t3.medium"
vpc_seurity_group_ids =[""]
key_name = "mykey"
 root_block_device {
   volume_size = 20
   volume_type = "gp2"
}
tages
