# Lattice Terraform templates for CloudStack

This project contains [Terraform](https://www.terraform.io/) templates to help you deploy
[Lattice](https://github.com/cloudfoundry-incubator/lattice) on
[Apache CloudStack](http://www.cloudstack.org/).

## Usage

### Configure

Update the `lattice.aws.tf` by filling in the values for the variables.  Details for the values of those variables are below.

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
* `num_cells`: The number of Lattice Cells to launch (default `3`)
* `lattice_username`: Lattice username (default `user`)
* `lattice_password`: Lattice password (default `pass`)


### Deploy

Here are some step-by-step instructions for deploying a Lattice cluster via Terraform:

1. Run the following commands in the folder containing the `lattice.aws.tf` file

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

Refer to the [Lattice CLI](../../ltc) documentation.

### Destroy

Destroy the cluster:

```
terraform destroy
```

