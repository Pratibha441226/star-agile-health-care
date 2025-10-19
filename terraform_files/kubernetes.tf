provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "kubernetes-server" {
  ami                    = "ami-07f07a6e1060cd2a8"
  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-0e572ed58dbc9ec7c"]
  key_name               = "mykey"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "kubernetes-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
      "sudo cp /home/ubuntu/minikube-linux-amd64 /usr/local/bin/minikube",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/stable.txt)/bin/linux/amd64/kubectl",
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp /home/ubuntu/kubectl /usr/local/bin/kubectl",
      "sudo groupadd docker || true",
      "sudo usermod -aG docker ubuntu"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("./mykey.pem")
    }
  }
}
