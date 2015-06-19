output "lattice_target" {
    value = "${cloudstack_ipaddress.public_ip.ipaddress}.xip.io"
}

output "lattice_username" {
    value = "${var.lattice_username}"
}

output "lattice_password" {
    value = "${var.lattice_password}"
}
