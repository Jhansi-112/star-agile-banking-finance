resource "aws_instance" "test-server" {
  ami                    = "ami-05ffe3c48a9991133"
  instance_type          = "t2.micro"
  key_name               = "mykey-project"
  vpc_security_group_ids = ["sg-0e56c0369e252aaf1"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/new-project-key.pem") # Make sure this file exists in the same folder
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

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
  }
}
