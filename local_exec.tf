terraform {
  backend "local" {
    path = "/tmp/terraform/workspace/terraform.tfstate"
  }

}

provider "aws" {
  region = "ap-south-1"
  
}

resource "aws_instance" "backend" {
  ami                    = "ami-0c28d7c6dd94fb3a7"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]

}

resource "null_resource" "remote-exec-1" {
    connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    host        = "${aws_instance.backend.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install python sshpass -y",
    ]
  }
}

resource "null_resource" "ansible-main" {
provisioner "local-exec" {
  command = <<EOT
        sleep 100;
        > jenkinsci.ini;
        echo "[jenkinsci]"| tee -a jenkinsci.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        echo "${aws_instance.backend.public_ip}" | tee -a jenkinsci.ini;
        ansible-playbook  --key=${var.pvt_key} -i jenkinsci.ini ./ansible/04-Tomcat/web-playbook.yaml -u ubuntu -v
    EOT
}
}
