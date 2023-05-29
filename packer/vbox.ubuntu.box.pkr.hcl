packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "url_2204" {
  type = string
  default = "https://releases.ubuntu.com/jammy/ubuntu-22.04-live-server-amd64.iso"
}

variable "url_2004" {
  type = string
  default = "https://releases.ubuntu.com/focal/ubuntu-20.04.4-live-server-amd64.iso"
}

variable "sum_2204" {
  type = string
  default = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
}

variable "sum_2004" {
  type = string
  default = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
}

variable "vm_name" {
  type = string
  default = "override_me_please"
}


source "virtualbox-iso" "packer01" {
  guest_os_type = "Ubuntu_64"
  iso_url = "${var.url_2004}"
  iso_checksum = "${var.sum_2004}"
  cpus = "2"
  #memory = "2048"
  #disk_size = "10000"
  headless = false
  http_directory = "http"
  output_directory = "output/live-server/"
  vm_name = "${var.vm_name}"
  boot_wait = "3s"
  vboxmanage = [
     ["modifyvm", "{{.Name}}", "--nic1", "nat",],
     ["modifyvm", "{{.Name}}","--memory", "2048"],
     ["modifyvm", "{{.Name}}","--cpus", "2"],
  ]
  boot_command = [
        "<wait2><enter><wait1>",
        "<esc><f6><esc>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "<bs><bs><bs>",
        "/casper/vmlinuz ",
        "initrd=/casper/initrd ",
        "autoinstall ",
        "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}// ",
        "<wait><enter>"
    ]
  communicator = "ssh"
  ssh_timeout = "15m"
  ssh_username = "packer"
  ssh_password = "packer"
  ssh_handshake_attempts = "4000"
  ssh_pty = true
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  #shutdown_command = "shutdown -P now"
}

build {
  name = "packer01"
  source "source.virtualbox-iso.packer01" {
  }
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Path }}'"
    script = "scripts/apt-install-script.sh"
  }
  post-processor "vagrant" {
      compression_level = "8"
      output = "output/vagrant/ubuntu-2004-docker.box"
  }
  
}
