terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

provider "virtualbox" {
  # Configuration options
}

#note: terraform stored these images in cache (.terraform/virtualbox/) so running packer again with updates
#will not make the build until you delete the cache, i beleive this is called 'state'

resource "virtualbox_vm" "control" {
  count = 1
  name = format("k8scnode%02d", count.index + 1)
  image = "/Users/stephen.peters/Desktop/training/lfs258-cka/packer/output/vagrant/docker-control-2004-15G.box"
  cpus = 4
  memory = "4096 mib"
  user_data = file("user_data")

  network_adapter {
    #type = "bridged"
    type = "nat"
    #host_interface = "en0: Wi-Fi"
    host_interface = "vboxnet1"
    #known as enp0s17 
  }
}

resource "virtualbox_vm" "work" {
  count = 2
  name = format("k8swnode%02d", count.index + 1)
  image = "/Users/stephen.peters/Desktop/training/lfs258-cka/packer/output/vagrant/docker-worker-2004-15G.box"
  cpus = 2
  memory = "2048 mib"
  user_data = file("user_data")

  network_adapter {
    #type = "bridged"
    type = "nat"
    #host_interface = "en0: Wi-Fi"
    host_interface = "vboxnet1"
    #known as enp0s17 
  }
}

output "k8scnode01" {
  #value = element(virtualbox_vm.control.*.network_adapter.0.ipv4_address, 0)
  value = virtualbox_vm.control.0.network_adapter.0.ipv4_address
}
#
output "k8swnode01" {
  #value = element(virtualbox_vm.work.*.network_adapter.0.ipv4_address, 0)
  value = virtualbox_vm.work.0.network_adapter.0.ipv4_address
}
#
output "k8swnode02" {
  #value = element(virtualbox_vm.work.*.network_adapter.0.ipv4_address, 1)
  value = virtualbox_vm.work.0.network_adapter.0.ipv4_address
}