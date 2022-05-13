

variable "environment" {
  type        = string
  default     = "test"
  description = "Environment"
}

variable "prefix" {
  type        = string
  default     = "tfdemo"
  description = "Prefix for all resources"
}

variable "project" {
  type        = string
  default     = "learntf"
  description = "Name of the project"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/22"
  description = "IP address range for the VPC"
}
variable "pubsubnet_cidrs" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24", "10.10.7.0/24", "10.10.9.0/24", "10.10.11.0/24", ]
}

variable "websubnet_cidrs" {
  type    = list(string)
  default = ["10.10.2.0/24", "10.10.4.0/24", "10.10.6.0/24", "10.10.8.0/24", "10.10.10.0/24", "10.10.12.0/24", ]
}

# Common Variables

variable "public_key_path" {
  type = string
  description = "Path of the Public Key File" 
  default = "/opt/mylab/keys/cloudops.pub"
}


# Bastion Variables

variable "bastion_size" {
  type        = string
  default     = "t2.micro"
  description = "size of the bastion instance"
}

variable "bastion_source_ip" {
  type        = string
  default     = "45.117.65.87/32"
  description = "Source IP from SSH connection can be allowed"
}




variable "bastion_sg_rules" {
  type        = list(string)
  default     = ["22"]
  description = "List of ports to be opened to bastion"
}


# Variables related to web instances

variable "webnodes" {
  type        = number
  default     = 1
  description = "No of web ec2 instances"
}


variable "web_node_size" {
  type        = string
  default     = "t2.micro"
  description = "size of the bastion instance"
}


variable "web_sg_rules" {
  type    = list(string)
  default = ["80"]
}


# Variables related to db instances

variable "dbsubnet_cidrs" {
  type    = list(string)
  default = ["10.10.2.0/24", "10.10.4.0/24", "10.10.6.0/24", "10.10.8.0/24", "10.10.10.0/24", "10.10.12.0/24", ]
}



variable "dbnodes" {
  type        = number
  default     = 1
  description = "No of db ec2 instances"
}


variable "db_node_size" {
  type        = string
  default     = "t2.micro"
  description = "size of the bastion instance"
}


variable "db_sg_rules" {
  type    = list(string)
  default = ["3306"]
}