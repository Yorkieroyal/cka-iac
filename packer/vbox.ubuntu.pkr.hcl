#the objective of this Packer HCL is to take a vanilla ubuntu latest stable ISO
#and spit out an OVF and BOX fromatted files to run in Virtualbox

#start with the packer {} block. This will host the settings for packer
#to start and the plug-ins you are using in this build 

#Run with :-
#packer build -force -var cpu=3 -var ram=4096 -var disk=10000 -var vm_name=docker-control-2004  vbox.ubuntu.pkr.hcl
#I am setting three variables on the command line that are declared in the main hcl file.
#I'm using -force to overwrite any existing output


packer {
    required_plugins {
        virtualbox = {
            version = "= 1.0.2"
            source = "github.com/hashicorp/virtualbox"
        }
    }
}

#variables can be declared here or from a dedicated variables file, then set in the same files or via the command line.
#if the command line is used then the the variable nneds to be present here and will overrite the default if set.

variable "myvar1" {
  type = string 
  default = "a string of text"
  description = "what am i here for"
}

variable "url22" {
  type = string
  default = "https://releases.ubuntu.com/22.04.5/ubuntu-22.04.5-live-server-amd64.iso"
}

variable "url20" {
  type = string
  default = "https://releases.ubuntu.com/20.04.5/ubuntu-20.04.5-live-server-amd64.iso"
}

variable "sum22" {
  type = string
  default = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
}

variable "sum20" {
  type = string
  default = "5035be37a7e9abbdc09f0d257f3e33416c1a0fb322ba860d42d74aa75c3468d4"
}

variable "cpu" {
  type = string
  default = "3"
}

variable "ram" {
  type = string
  default = "4096"
}

variable "disk" {
  type = string
  default = "5000"
}

variable "ssh_user" {
  sensitive = true
  default = "packer"
}

variable "ssh_pass" {
  sensitive = true
  default = "packer"
}

variable "vm_name" {
  type = string
  default = "override_me_please"
}

source "virtualbox-iso" "ubuntu" {
  guest_os_type = "Ubuntu_64"
  disk_size = "${var.disk}"
  iso_url = "${var.url20}"
  iso_checksum = "${var.sum20}"
  ssh_username = "${var.ssh_user}"
  ssh_password = "${var.ssh_pass}"
  headless = false
  http_directory = "http"
  output_directory = "output/virtualbox/"
  vm_name = "${var.vm_name}"
  boot_wait = "5s"
  vboxmanage = [
     ["modifyvm", "{{.Name}}", "--nic1", "nat",],
     ["modifyvm", "{{.Name}}", "--nictype1", "82545EM"],
     #the next statements are optional with extra interface types
     #["modifyvm", "{{.Name}}", "--nic2", "hostonly"],
     #["modifyvm", "{{.Name}}", "--nictype2", "82545EM"],
     #["modifyvm", "{{.Name}}", "--hostonlyadapter2", "vboxnet0"],
     #["modifyvm", "{{.Name}}", "--nic3", "bridged"],
     #["modifyvm", "{{.Name}}", "--bridgeadapter3", "en0: Wi-Fi (Wireless)"],
     #["modifyvm", "{{.Name}}", "--nictype3", "82545EM"],
     #vboxmanage list hostonlyifs --> will list the network we need for the above command
     ["modifyvm", "{{.Name}}","--memory", "${var.ram}"],
     ["modifyvm", "{{.Name}}","--cpus", "${var.cpu}"],
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
        "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ ",
        "<wait><enter><wait2>"
    ]
  communicator = "ssh"
  ssh_timeout = "15m"
  ssh_handshake_attempts = "4000"
  ssh_pty = true
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now" 
}

build {
  name = "ubuntu20-docker"
  source "source.virtualbox-iso.ubuntu" {
  }
  provisioner "file" {
    sources = ["files/kubernetes.list","files/calico.yaml","files/daemon.json"]
    destination = "/tmp/"
  }
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Path }}'"
    scripts = ["scripts/file-move-script.sh","scripts/apt-install-script.sh","scripts/guest-additions-script.sh","scripts/reboot.sh"]
    pause_before = "1m"
    pause_after = "1m"
    start_retry_timeout = "2m"
    expect_disconnect = true
  }  
  post-processor "vagrant" {
      compression_level = "6"
      #Specify the compression level, for algorithms that support it, from 1 through 9 inclusive.
      #Typically higher compression levels take longer but produce smaller files.
      #Defaults to 6
      output = "output/vagrant/${var.vm_name}.box"
      keep_input_artifact = false
  }
}