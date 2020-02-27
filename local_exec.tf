terraform {
  backend "local" {
    path = "/tmp/terraform/workspace/terraform.tfstate"
  }

}

provider "aws" {
  region = "us-west-2"
  
}

resource "aws_instance" "backend" {
  ami                    = "ami-0994c095691a46fb5"
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
        > inventory;
        echo "[web]"| tee -a inventory;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        echo "${aws_instance.backend.public_ip}" | tee -a inventory;
        ansible-playbook -i /root/pipe-Terraform/inventory -u ubuntu --key /root/.ssh/vinnikey.pem web-playbook.yaml'
 
    EOT
}
}
