provider "cloudstack" {
  api_url   = "http://192.168.59.103:8080/client/api"
  api_key    = "qymoVoXjyzk8n6cLNN-JTyFRrD5lvH01RWB6f9r6UonurXaFPzWy0uAJikCZiGzr5yqpZpSeey2L-AXY7hwKLA"
  secret_key = "WmhqrS8uG8CVzTDo06cQCX8l2PdB0l7X1D9mSKu0ok_ivenD3mLcrAsxB2OU-ILJajNHyBJuexRg8DrEylRQGQ"
}


resource "cloudstack_network" "Network01" {
    name = "Network01"
    display_text = "Network01"
    cidr = "10.0.10.0/24"
    network_offering = "DefaultIsolatedNetworkOfferingWithSourceNatService"
    zone = "zone002"
}

resource "cloudstack_network" "Network02" {
    name = "Network02"
    display_text = "Network02"
    cidr = "10.0.20.0/24"
    network_offering = "DefaultIsolatedNetworkOfferingWithSourceNatService"
    zone = "zone002"
}

resource "cloudstack_instance" "VMM001" {
  zone = "zone002"
  service_offering = "t1.micro"
  template = "CentOS6.5"
  name = "VMM001"
  network = "${cloudstack_network.Network01.id}"
  expunge = "true"
}

resource "cloudstack_instance" "VMM002" {
  zone = "zone002"
  service_offering = "t1.micro"
  template = "CentOS6.5"
  name = "VMM002"
  network = "${cloudstack_network.Network02.id}"
  expunge = "true"
}

resource "cloudstack_nic" "VMM001-Network02" {
    network = "${cloudstack_network.Network02.id}"
    virtual_machine = "${cloudstack_instance.VMM001.name}"
}

