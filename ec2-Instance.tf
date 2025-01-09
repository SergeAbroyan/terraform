# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-01816d07b1128cd2d" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.allow_ssh.id]
  key_name      = aws_key_pair.generated_key.key_name # Associate the key pair


#   user_data = templatefile("${path.module}/monitoring/combined_userdata.tpl", {
#   prometheus_userdata = file("${path.module}/monitoring/prometheus_userdata.yaml"),
#   grafana_userdata    = file("${path.module}/monitoring/grafana_userdata.yaml")
# })



  tags = {
    Name = "ec2-instance"
  }


}

# Generate the Ansible inventory file dynamically
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/hosts.yml"
  content  = <<EOT
all:
  hosts:
    ec2_instance:
      ansible_host: ${aws_instance.ec2_instance.public_ip}
      ansible_user: ec2-user
      ansible_ssh_private_key_file: ${local_file.private_key_file.filename}
EOT
  depends_on = [aws_instance.ec2_instance]
}

resource "null_resource" "ansible_provision" {
  depends_on = [aws_instance.ec2_instance, local_file.ansible_inventory, null_resource.wait_for_instance]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${path.module}/ansible/inventory/hosts.yml -u ec2-user --private-key ${path.module}/awsid_rsa ${path.module}/ansible/playbook.yml"
  }
}

resource "null_resource" "wait_for_instance" {
  depends_on = [aws_instance.ec2_instance]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
