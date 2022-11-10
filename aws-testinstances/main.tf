# Child Module for creating test instances in AWS


resource "aws_instance" "ec2_test_inst" {
  for_each = {
    for index , subnet in local.deploy_insts : "inst_${index}" => subnet
  }
 
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [aws_security_group.test_inst_allow_all.id]
  key_name                    = var.key_name
  associate_public_ip_address = var.need_public_ip
  user_data = <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt install iperf3 -y
                  sudo apt install nginx -y 
                  wget https://github.com/microsoft/ethr/releases/latest/download/ethr_linux.zip
                  unzip ethr_linux.zip
                  sudo apt install inetutils-traceroute 
        EOF
        
  tags = var.custom_tags
   
}


resource "aws_security_group" "test_inst_allow_all" {
  
  name     = var.security_group_name
  vpc_id   = var.secgrp_vpc_id
 
 ingress {
    from_port   = local.port_any
    to_port     = local.port_any
    protocol    = local.protocol_any
    cidr_blocks = local.all_ip
  }
 egress {
    from_port   = local.port_any
    to_port     = local.port_any
    protocol    = local.protocol_any
    cidr_blocks = local.all_ip
  }
}
