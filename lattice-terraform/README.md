# Lattice Terraform templates for CloudStack

This project contains [Terraform](https://www.terraform.io/) templates to help you deploy
[Lattice](https://github.com/cloudfoundry-incubator/lattice) on
[Apache CloudStack](http://www.cloudstack.org/).

## Usage
### Prerequisites
* CloudStack  with Advanced Zone (uses VPC) (tested 4.5)
* Any  hypervisor (tested : XenServer 6.5)
* terraform >= v0.5.3
* Ubuntu 14.04 template with 'make' and 'gcc' installed
  (for example: http://dl.openvm.eu/cloudstack/ubuntu/vanilla/14.04/x86_64/  doesn't have it, so the provisioning script for lattice-cell installs gcc and make)
* API and secret keys for your CloudStack
* ssh keypair (using `cloudmonkey`: `cloudmonkey create sshkeypair name=lattice`)

### Configure

Clone this repository to your local disk. Copy out the `example/lattice.cloudstack.tf` to another directory. Edit the file to point the `source` variable to the absolute path to the `terraform-cloudstack-examples/lattice-terraform/cloudstack` directory that got created by the `git clone`.

Update the `lattice.cloudstack.tf` by filling in the values for the variables.  Details for the values of those variables are below.

The available variables that can be configured are:

* `cs_access_key`: CloudStack API key
* `cs_secret_key`: CloudStack secret key
* `cs_key_name`: The SSH key name to use for the instances
* `cs_ssh_private_key_file`: Path to the SSH private key file
* `cs_ssh_user`: SSH user (default `ubuntu`)
* `cs_vpc_cidr_block`: The IPv4 address range that machines in the network are assigned to, represented as a CIDR block 
* `cs_subnet_cidr_block`: The IPv4 address range that machines in the network are assigned to, represented as a CIDR block 
* `cs_image`: The name of the image to base the launched instances (default `ubuntu trusty 64bit hvm ami`)
* `cs_instance_type_brain`: The machine type to use for the Lattice Brain instance 
* `cs_instance_type_cell`: The machine type to use for the Lattice Cells instances 
* `lattice_brain_private_ip`: Static IP in the subnet cidr block for the brain
* `num_cells`: The number of Lattice Cells to launch (default `3`)
* `lattice_username`: Lattice username (default `lattice`)
* `lattice_password`: Lattice password (default `lattice`)


### Deploy

Here are some step-by-step instructions for deploying a Lattice cluster via Terraform:

1. Run the following commands in the new folder containing the `lattice.cloudstack.tf` file

  ```bash
  terraform get -update
  terraform apply
  ```

  This will deploy the cluster.

Upon success, terraform will print the Lattice target:

```
Outputs:

  lattice_target = x.x.x.x.xip.io
  lattice_username = xxxxxxxx
  lattice_password = xxxxxxxx
```

which you can use with the Lattice CLI to `ltc target x.x.x.x.xip.io`.

Terraform will generate a `terraform.tfstate` file.  This file describes the cluster that was built - keep it around in order to modify/tear down the cluster.

### Use

Refer to the [Lattice CLI](https://github.com/cloudfoundry-incubator/lattice/tree/master/ltc) documentation.

### Destroy

Destroy the cluster:

```
terraform destroy
```
### How the terraform script works
 - creates a VPC ("name = lattice")
 - creates ACL to let all ports through on egress and ingress
 - creates a subnet in the VPC (name = "lattice") and attaches ACL
 - allocates a new public IP for the VPC
 - creates lattice-brain VM with static IP
 - creates port forwarding to the lattice brain ssh port so that terraform remote provisioner can work
 - creates lattice-cell VMs 
 - creates port forwarding to the lattice cell ssh ports so that terraform remote provisioner can work
 - in contrast to AWS recipe, provisioners run on the 'port_forward' resource since they can only work after the port_forward resource is created. The port_forward resource can only work after the VM is created.
 
