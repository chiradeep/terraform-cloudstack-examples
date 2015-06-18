# Kubernetes deployment using CoreOS on a single isolated network

## Usage
 - `cd kubernetes; terraform plan; terraform apply`

## Notes
 - terraform 0.5.3 requires a fix (https://github.com/hashicorp/terraform/pull/2391)
 - Register one of the "CoreOS" template from this URL: http://dl.openvm.eu/cloudstack/coreos/x86_64/
 - Replace ssh public key at bottom of cloud_config/*.yaml with your own
 - master/node config taken from https://github.com/GoogleCloudPlatform/kubernetes/tree/master/docs/getting-started-guides/coreos/cloud-configs
 - uses **host-gw** method of flannel networking instead of overlay. To use 'vxlan', search and replace host-gw with vxlan
