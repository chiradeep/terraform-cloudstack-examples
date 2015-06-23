resource "cloudstack_network" "network01" {
    name = "${var.cs_network_name}"
    display_text = "${var.cs_network_name}"
    cidr = "${var.cs_nw_cidr_block}"
    network_offering = "DefaultIsolatedNetworkOfferingWithSourceNatService"
    zone = "${var.cs_zone}"
}

resource "cloudstack_egress_firewall" "network01" {
  network = "${var.cs_network_name}"
  depends_on = ["cloudstack_network.network01", "cloudstack_instance.instance"]

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["1-65535"]
  }

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "udp"
    ports = ["1-65535"]
  }

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "icmp"
    icmp_type = "-1"
    icmp_code = "-1"
  }
}

resource "cloudstack_firewall" "ssh" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"
  count = "${var.num_instances}"

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["${count.index+var.cs_ssh_port_start}"]
  }
}


resource "cloudstack_instance" "instance" {
    count = "${var.num_instances}"
    template = "${var.cs_image}"
    service_offering = "${var.cs_instance_type}"
    keypair = "${var.cs_key_name}"
    network = "${cloudstack_network.network01.id}"
    name = "instance-${count.index}"
    zone = "${var.cs_zone}"
    expunge = "true"

}


resource "cloudstack_ipaddress" "public_ip" {
    network = "${cloudstack_network.network01.id}"
    depends_on = ["cloudstack_instance.instance"]
}

resource "cloudstack_port_forward" "ssh" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"
  depends_on = ["cloudstack_instance.instance"]
  count = "${var.num_instances}"

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "${count.index+var.cs_ssh_port_start}"
    virtual_machine = "${element(cloudstack_instance.instance.*.name, count.index)}"
  }

  connection {
        host = "${cloudstack_ipaddress.public_ip.ipaddress}"
        user = "${var.cs_ssh_user}"
        key_file = "${var.cs_ssh_private_key_file}"
        port = "${count.index+var.cs_ssh_port_start}"
  }

  provisioner "remote-exec" {
      inline = [
          "echo \"Completed terraform provisioning\" > ~/install.log"
      ]
    }
}
