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

variable "cs_vpc_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "172.16.0.0/16"
}

variable "cs_subnet_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "172.16.1.0/24"
}

variable "cs_image" {
    description = "The name of the image to base the launched instances."
    default = "Ubuntu1404"
}

variable "cs_instance_type_brain" {
    description = "The machine type to use for the Lattice Brain instance."
    default = "t1.micro"
}

variable "cs_instance_type_cell" {
    description = "The machine type to use for the Lattice Cells instances."
    default = "t1.micro"
}

variable "lattice_brain_private_ip" {
    description = "The private IP reserved for the lattice brain"
    default = "172.16.1.10"
}

variable "num_cells" {
    description = "The number of Lattice Cells to launch."
    default = "3"
}

variable "lattice_username" {
    description = "Lattice username."
    default = "lattice"
}

variable "lattice_password" {
    description = "Lattice password."
    default = "lattice"
}

variable "local_lattice_tar_path" {
    description = "Path to the lattice tar, to deploy to your cluster. If not provided, then by default, the provisioner will download the latest lattice tar to a .lattice directory within your module path"
    default=".lattice/lattice.tgz"
}
