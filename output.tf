output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}



output "private_key" {
  value     = tls_private_key.aws_key.private_key_pem
  sensitive = true
}


# Output the public key for reference
output "public_key" {
  value = tls_private_key.aws_key.public_key_openssh
}

# Output the AWS key pair name
output "key_pair_name" {
  value = aws_key_pair.generated_key.key_name
}

output "private_key_path" {
  value = local_file.private_key_file.filename
}



output "public_key_path" {
  value = local_file.public_key_file.filename
}

