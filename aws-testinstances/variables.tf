variable "ec2_instance_type" {
    type = string
    description = "Instance type for testing"
    default = "t2.micro"
}
variable "ami_id" {
    type = string
    description = "Instance AMI"
}
variable "subnet_ids" {
    type = list(string)
    description = "list of Subnet ids where you want the instance to be deployed"
}

variable "key_name" {
    type = string
    description = "Key name in aws to use"  

}
variable "need_public_ip" {
    type = bool
    description = "Set true for instances in public subnets that can accessed over internet directly, else flse. Set flase for private Subnets"
    default = "false" 
}

variable "custom_tags" {
    type = map(string)
    description = "Required ec2 instance tags"
    default = {}
}

variable "secgrp_vpc_id" {
    type = string
    description = "vpc_id"
}

variable "num_insts_per_subnet" {
  type = number 
  description = "Number of instances to deploy per subnet"
  default = 1 
}

variable "instance_name" {
  type = string
  description = "Name for the instance. It will be suffixed with number"
  default = "test_instance"
}

variable "security_group_name"{
    type = string  
    description = "Name of security group to create"
    default = "test_pvt_inst_allow_all"
}

locals {
# SG related locals 
    http_port     = 80
    https_port    = 443
    ssh_port      = 22
    ike_port      = 500
    ike_natt_port = 4500
    port_any      = 0
    protocol_tcp  = "tcp"
    protocol_udp  = "udp"
    protocol_icmp = "icmp"
    protocol_any  = "-1"
    all_ip        = ["0.0.0.0/0"]

# Map of values to deploy instances in
# For each subnet deploy num_insts_per_subnet instances

    deploy_insts = flatten([
        for subnet in var.subnet_ids: [
            for index , inst in range(0,var.num_insts_per_subnet,1):{
                subnet_id                   = subnet
/*                 tags = {
                    for key , tag in var.custom_tags : key => "tag_{$index}" if key == Name 
                }  */
            }
        ]
    ]) 

}
