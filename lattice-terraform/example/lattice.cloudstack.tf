module "lattice-cs" {
    source = "./cloudstack"

    # CS access key
    cs_api_key = "bfKSyLg0IHf2YauYxnHQnmryISeXEJCY8bFwttV5A4F8C25oYTc_V1sIuLZCI7TyuEmlbpTsK-7EHxb908jj9g"

    # CS secret key
    cs_secret_key = "rl1ID3ILQlRbeWS_XoAQu9b6O1caTUE1R1xtzklN93WNWQe3TkdY8ZBldDkTdrsFwkFmBH2AZ7wBhgGSwluGxQ"

    # The SSH key name to use for the instances
    cs_key_name = "lattice"

    # Path to the SSH private key file
    cs_ssh_private_key_file = "./lattice.pem"

    # cloudstack zone name
    cs_zone = "zone001"

    # The number of Lattice Cells to launch
    num_cells = "3"

}

output "lattice_target" {
    value = "${module.lattice-cs.lattice_target}"
}

output "lattice_username" {
    value = "${module.lattice-cs.lattice_username}"
}

output "lattice_password" {
    value = "${module.lattice-cs.lattice_password}"
}
