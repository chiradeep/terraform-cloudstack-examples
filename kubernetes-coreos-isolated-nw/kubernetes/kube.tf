provider "cloudstack" {
 api_url   = "http://${var.ms_host}:8080/client/api"
 api_key = "${var.access_key}"
 secret_key = "${var.secret_key}"
}

resource "cloudstack_network" "Network01" {
    name = "Network01"
    display_text = "Network01"
    cidr = "192.168.1.0/24"
    network_offering = "DefaultIsolatedNetworkOfferingWithSourceNatService"
    zone = "zone001"
}



resource "cloudstack_instance" "kube-01" {
  zone = "zone001"
  service_offering = "t1.micro"
  template = "CoreOS"
  name = "kube-01"
  network = "${cloudstack_network.Network01.id}"
  expunge = "true"
  ipaddress = "192.168.1.10"
  user_data = "${file("../cloud-config/master.yaml")}"

}

resource "cloudstack_instance" "kube-02" {
  zone = "zone001"
  service_offering = "t1.micro"
  template = "CoreOS"
  name = "kube-02"
  network = "${cloudstack_network.Network01.id}"
  expunge = "true"
  ipaddress = "192.168.1.11"
  user_data = "${file("../cloud-config/node.yaml")}"

}

resource "cloudstack_instance" "kube-03" {
  zone = "zone001"
  service_offering = "t1.micro"
  template = "CoreOS"
  name = "kube-03"
  network = "${cloudstack_network.Network01.id}"
  expunge = "true"
  ipaddress = "192.168.1.12"
  user_data = "${file("../cloud-config/node.yaml")}"
}

resource "cloudstack_ipaddress" "public_ip" {
  network = "${cloudstack_network.Network01.id}"
  depends_on = ["cloudstack_instance.kube-01"]
}

resource "cloudstack_firewall" "public_ip" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"

  rule {
    source_cidr = "0.0.0.0/0"
    protocol = "tcp"
    ports = ["1222","2222","3222", "80","8080"]
  }
}

resource "cloudstack_port_forward" "ssh_api_server" {
  ipaddress = "${cloudstack_ipaddress.public_ip.id}"
  depends_on = ["cloudstack_firewall.public_ip"]
  depends_on = ["cloudstack_instance.kube-01"]
  depends_on = ["cloudstack_instance.kube-02"]
  depends_on = ["cloudstack_instance.kube-03"]

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "1222"
    virtual_machine = "kube-01"
  }

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "2222"
    virtual_machine = "kube-02"
  }

  forward {
    protocol = "tcp"
    private_port = "22"
    public_port = "3222"
    virtual_machine = "kube-03"
  }

  forward {
    protocol = "tcp"
    private_port = "8080"
    public_port = "8080"
    virtual_machine = "kube-01"
  }
}
