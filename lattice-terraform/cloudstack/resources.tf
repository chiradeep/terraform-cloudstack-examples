resource "cloudstack_vpc" "lattice-network" {
    cidr = "${var.cs_vpc_cidr_block}"
    name = "lattice"
    vpc_offering = "Default VPC Offering" 
    zone = "${var.cs_zone}"
}

resource "cloudstack_network" "lattice-network" {
    name = "lattice"
    display_text = "lattice"
    cidr = "${var.cs_subnet_cidr_block}"
    network_offering = "DefaultIsolatedNetworkOfferingForVpcNetworks"
    aclid = "${cloudstack_network_acl.lattice-network.id}"
    zone = "${var.cs_zone}"
    vpc = "${cloudstack_vpc.lattice-network.id}"
}

resource "cloudstack_network_acl" "lattice-network" {
    depends_on = ["cloudstack_vpc.lattice-network"]
    name = "lattice-acl"
    vpc = "lattice"
}

resource "cloudstack_network_acl_rule" "lattice-rule" {
  aclid = "${cloudstack_network_acl.lattice-network.id}"

  rule {
    action = "allow"
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["1-65000"]
    traffic_type = "ingress"
  }
  rule {
    action = "allow"
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["1-65000"]
    traffic_type = "egress"
  }
  rule {
    action = "allow"
    source_cidr = "0.0.0.0/0"
    protocol = "udp"
    ports = ["1-65000"]
    traffic_type = "ingress"
  }
  rule {
    action = "allow"
    source_cidr = "0.0.0.0/0"
    protocol = "udp"
    ports = ["1-65000"]
    traffic_type = "egress"
  }
}

resource "cloudstack_ipaddress" "public_ip" {
    depends_on = ["cloudstack_instance.lattice-brain"]
    vpc = "${cloudstack_vpc.lattice-network.id}"
}

resource "cloudstack_port_forward" "lattice-brain" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "1222"
    virtual_machine = "${cloudstack_instance.lattice-brain.name}"
  }

  forward {
    protocol = "tcp"
    private_port = "80"
    public_port = "80"
    virtual_machine = "${cloudstack_instance.lattice-brain.name}"
  }
  connection {
        host = "${cloudstack_ipaddress.public_ip.ipaddress}"
        user = "${var.cs_ssh_user}"
        key_file = "${var.cs_ssh_private_key_file}"
        port = "1222"
  }
  #COMMON
  provisioner "local-exec" {
    command = "LOCAL_LATTICE_TAR_PATH=${var.local_lattice_tar_path} LATTICE_VERSION_FILE_PATH=${path.module}/../Version ${path.module}/../scripts/local/download-lattice-tar"
    }

  provisioner "file" {
     source = "${var.local_lattice_tar_path}"
      destination = "/tmp/lattice.tgz"
    }

   provisioner "file" {
     source = "${path.module}/../scripts/remote/install-from-tar"
      destination = "/tmp/install-from-tar"
    }

   provisioner "remote-exec" {
      inline = [
          "sudo chmod 755 /tmp/install-from-tar",
          "sudo bash -c \"echo 'PATH_TO_LATTICE_TAR=${var.local_lattice_tar_path}' >> /etc/environment\"" #SHOULDN'T PATH_TO_LATTICE_TAR be set to /tmp/lattice.tgz???
      ]
    }
    #/COMMON

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /var/lattice/setup",
            "sudo sh -c 'echo \"LATTICE_USERNAME=${var.lattice_username}\" > /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"LATTICE_PASSWORD=${var.lattice_password}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"CONSUL_SERVER_IP=${var.lattice_brain_private_ip}\" >> /var/lattice/setup/lattice-environment'",
        ]
    }

    provisioner "remote-exec" {
        script = "${path.module}/../scripts/remote/install-brain"
    }
  provisioner "remote-exec" {
        inline = [       
          "sudo sh -c 'echo \"SYSTEM_DOMAIN=${cloudstack_ipaddress.public_ip.ipaddress}.xip.io\" >> /var/lattice/setup/lattice-environment'",
          "sudo restart receptor",
          "sudo restart trafficcontroller"
        ]   
  }

}


resource "cloudstack_instance" "lattice-brain" {
    template = "${var.cs_image}"
    service_offering = "${var.cs_instance_type_brain}"
    keypair = "${var.cs_key_name}"
    network = "${cloudstack_network.lattice-network.id}"
    name = "lattice-brain"
    ipaddress = "${var.lattice_brain_private_ip}"
    zone = "${var.cs_zone}"
    expunge = "true"


}

resource "cloudstack_instance" "lattice-cell" {
    depends_on = ["cloudstack_ipaddress.public_ip"]
    depends_on = ["cloudstack_instance.lattice-brain"]
    count = "${var.num_cells}"
    template = "${var.cs_image}"
    service_offering = "${var.cs_instance_type_brain}"
    keypair = "${var.cs_key_name}"
    network = "${cloudstack_network.lattice-network.id}"
    name = "cell-${count.index}"
    zone = "${var.cs_zone}"
    expunge = "true"

}

resource "cloudstack_port_forward" "lattice-cell" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"
  depends_on = ["cloudstack_instance.lattice-cell"]
  count = "${var.num_cells}"

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "${count.index+1223}"
    virtual_machine = "${element(cloudstack_instance.lattice-cell.*.name, count.index)}"
  }

  connection {
        host = "${cloudstack_ipaddress.public_ip.ipaddress}"
        user = "${var.cs_ssh_user}"
        key_file = "${var.cs_ssh_private_key_file}"
        port = "${count.index+1223}"
  }

  #COMMON
   provisioner "local-exec" {
      command = "LOCAL_LATTICE_TAR_PATH=${var.local_lattice_tar_path} LATTICE_VERSION_FILE_PATH=${path.module}/../Version ${path.module}/../scripts/local/download-lattice-tar"
    }

   provisioner "file" {
      source = "${var.local_lattice_tar_path}"
      destination = "/tmp/lattice.tgz"
    }

   provisioner "file" {
      source = "${path.module}/../scripts/remote/install-from-tar"
      destination = "/tmp/install-from-tar"
    }

   provisioner "remote-exec" {
      inline = [
          "sudo chmod 755 /tmp/install-from-tar",
          "sudo bash -c \"echo 'PATH_TO_LATTICE_TAR=${var.local_lattice_tar_path}' >> /etc/environment\""
      ]
    }
    #/COMMON

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /var/lattice/setup",
            "sudo sh -c 'echo \"CONSUL_SERVER_IP=${cloudstack_instance.lattice-brain.ipaddress}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"SYSTEM_DOMAIN=${cloudstack_ipaddress.public_ip.ipaddress}.xip.io\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"LATTICE_CELL_ID=cell-${count.index}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"GARDEN_EXTERNAL_IP=$(hostname -I | awk '\"'\"'{ print $1 }'\"'\"')\" >> /var/lattice/setup/lattice-environment'",
            "sudo apt-get -y update",
            "sudo apt-get -y install gcc make"
        ]
    }

    provisioner "remote-exec" {
        script = "${path.module}/../scripts/remote/install-cell"
    }

}


