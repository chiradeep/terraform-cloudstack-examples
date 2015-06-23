output "public_ip" {
    value = "${cloudstack_ipaddress.public_ip.ipaddress}"
}

output "ssh_ports" {
    value = "${formatlist(\"instance %v can be accessed on ssh on public ip  %v, port %v\", cloudstack_instance.instance.*.name, cloudstack_ipaddress.public_ip.ipaddress, cloudstack_port_forward.ssh.*.public_port)}"
}

