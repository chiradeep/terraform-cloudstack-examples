provider "cloudstack" {
  api_url   = "http://192.168.59.103:8080/client/api"
  api_key    = "qymoVoXjyzk8n6cLNN-JTyFRrD5lvH01RWB6f9r6UonurXaFPzWy0uAJikCZiGzr5yqpZpSeey2L-AXY7hwKLA"
  secret_key = "WmhqrS8uG8CVzTDo06cQCX8l2PdB0l7X1D9mSKu0ok_ivenD3mLcrAsxB2OU-ILJajNHyBJuexRg8DrEylRQGQ"
}

resource "cloudstack_vpc" "default" {
    name = "test-vpc"
    display_text = "test-vpc"
    cidr = "10.0.0.0/16"
    vpc_offering = "Default VPC Offering"
    zone = "zone002"
}

resource "cloudstack_network_acl" "default" {
    name = "test-acl"
    vpc = "${cloudstack_vpc.default.id}"
}

resource "cloudstack_network" "subnet-1" {
    name = "subnet-1"
    display_text = "subnet-1"
    cidr = "10.0.10.0/24"
    network_offering = "DefaultIsolatedNetworkOfferingForVpcNetworks"
    #aclid = "${cloudstack_network_acl.default.id}"
    zone = "zone002"
    vpc = "${cloudstack_vpc.default.id}"
}

resource "cloudstack_network" "subnet-2" {
    name = "subnet-2"
    display_text = "subnet-2"
    cidr = "10.0.20.0/24"
    network_offering = "DefaultIsolatedNetworkOfferingForVpcNetworksNoLB"
    #aclid = "${cloudstack_network_acl.default.id}"
    vpc = "${cloudstack_vpc.default.id}"
    zone = "zone002"
}

resource "cloudstack_instance" "vm01" {
  zone = "zone002"
  service_offering = "t1.micro"
  template = "CentOS6.5"
  name = "vm01-subnet-1"
  network = "${cloudstack_network.subnet-1.id}"
}

resource "cloudstack_instance" "vm02" {
  zone = "zone002"
  service_offering = "t1.micro"
  template = "CentOS6.5"
  name = "vm02-subnet-2"
  network = "${cloudstack_network.subnet-2.id}"
}
