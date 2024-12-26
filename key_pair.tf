resource "tls_private_key" "aws_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an AWS Key Pair using the generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "awsid_rsa_key" # Name for the key pair in AWS
  public_key = tls_private_key.aws_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key_file" {
  filename        = "${path.module}/awsid_rsa" # Save the private key to the current directory
  content         = tls_private_key.aws_key.private_key_pem
  file_permission = "0400" # Restrict file permissions for security
  depends_on      = [tls_private_key.aws_key]
}

# Save the public key to a local file (optional)
resource "local_file" "public_key_file" {
  filename   = "${path.module}/awsid_rsa.pub"
  content    = tls_private_key.aws_key.public_key_openssh
  file_permission = "0644"
  depends_on = [tls_private_key.aws_key]
  
}