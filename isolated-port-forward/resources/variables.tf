variable "cs_api_url" {
    description = "CS api URL (e.g.,) http://10.10.33.99:8080/client/api."
}

variable "cs_api_key" {
    description = "CS api key."
}

variable "cs_secret_key" {
    description = "CS secret key."
}

variable "cs_key_name" {
    description = "The SSH key name to use for the instances."
}

variable "cs_ssh_private_key_file" {
    description = "Path to the SSH private key file."
}

variable "cs_ssh_user" {
    description = "SSH user."
    default = "ubuntu"
}

variable "cs_zone" {
    description = "Zone name"
}

variable "cs_nw_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to."
    default = "172.16.0.0/24"
}

variable "cs_image" {
    description = "The name of the image to base the launched instances."
    default = "Ubuntu1404"
}

variable "cs_instance_type" {
    description = "The machine type to use for the  instance."
    default = "t1.micro"
}

variable "cs_instance_basename" {
    description = "Name to derive the machine name to assign the instance"
    default = "vm"
}

variable "num_instances" {
    description = "The number of instances to launch."
    default = "3"
}

variable "cs_network_name" {
    description = "The name of the network to create and launch instances into"
    default = "subnet01"
}

variable "cs_ssh_port_start" {
    description = "The port on the public ip that is forwarded to the ssh port of the first instance. Subsequent instances get the port incremented"
    default = "1222"
}

