resource "aws_instance" "test-server1" {
  ami                    = "ami-05ffe3c48a9991133"
  instance_type          = "t2.micro"
  key_name               = "new-project-key"
  vpc_security_group_ids = ["sg-0e56c0369e252aaf1"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/new-project-key.pem")  # This file must be present in terraform-files directory
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'wait to start the instance'"
    ]
  }

  tags = {
    Name = "test-server1"
  }

  # Save EC2 public IP to inventory file
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  # Run Ansible playbook with proper key and inventory
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory ansibleplaybook.yml --private-key=new-project-key.pem"
  }
}

