# Deploy multiple instances to an isolated network


## Usage
### Prerequisites
* CloudStack  with Advanced Zone 
* Any  hypervisor 
* terraform >= v0.5.3
* API and secret keys for your CloudStack
* ssh keypair (using `cloudmonkey`: `cloudmonkey create sshkeypair name=foo`)

### Configure

Clone this repository to your local disk. Copy out the `example/isolated-pf.tf` to another directory. Edit the file to point the `source` variable to the absolute path to the `terraform-cloudstack-examples/isolated-port-forward/resources` directory that got created by the `git clone`.

Update the `isolated-pf.tf` by filling in the values for the variables.  Details for the values of those variables are below.

The available variables that can be configured are:

* `cs_access_key`: CloudStack API key
* `cs_secret_key`: CloudStack secret key
* `cs_key_name`: The SSH key name to use for the instances
* `cs_ssh_private_key_file`: Path to the SSH private key file
* `cs_ssh_user`: SSH user (default `ubuntu`)
* `cs_nw_cidr_block`: The IPv4 address range that machines in the network are assigned to"
* `cs_image`: The name of the image to base the launched instances (default `ubuntu trusty 64bit hvm ami`)
* `cs_instance_type`: The machine type to use for the  instances
* `num_instances`: The number of instances to launch (default `3`)
* `cs_ssh_port_start`: The port on the public ip that is forwarded to the ssh port of the first instance. Subsequent instances get the port incremented


### Deploy

Here are some step-by-step instructions for deploying a Lattice cluster via Terraform:

1. Run the following commands in the new folder containing the `lattice.cloudstack.tf` file

  ```bash
  terraform get -update
  terraform apply
  ```

  This will deploy the instances

Upon success, terraform will print the Lattice target:

```
Outputs:

  public_ip = xx.xx.xx.xx
```

Terraform will generate a `terraform.tfstate` file.  This file describes the cluster that was built - keep it around in order to modify/tear down the cluster.

### Use

The instances can be accessed via ssh on the public ip's port designated by the variable cs_ssh_port_start. The first instance can be accessed on port `cs_ssh_port_start`, the second one on `cs_ss_port_start+1` etc.

A simple provisioning example is provided, these can be expanded (see resource `cloudstack_port_forward`

### Destroy

Destroy the cluster:

```
terraform destroy
```
