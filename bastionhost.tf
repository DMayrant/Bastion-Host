resource "aws_instance" "bastion_host" {
  ami                         = "ami-0bdd88bd06d16ba03"
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
 key_name                     = aws_key_pair.linux_key.key_name
  vpc_security_group_ids      = [aws_security_group.linux_sg.id]
  monitoring = true
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = "Bastion Host"

  })

}

resource "tls_private_key" "linux_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the generated public key
resource "aws_key_pair" "linux_key" {
  key_name   = "linux-prod"
  public_key = tls_private_key.linux_key.public_key_openssh
}
