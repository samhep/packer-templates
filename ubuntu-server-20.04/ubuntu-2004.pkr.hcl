variable "iso_url" {
  type    = string
  default = "[nuc03-local] ISOs/ubuntu-20.04.2-live-server-amd64.iso"
}

variable "vm-cpu-num" {
  type    = string
  default = "2"
}

variable "vm-disk-size" {
  type    = string
  default = "25600"
}

variable "vm-mem-size" {
  type    = string
  default = "1024"
}

variable "vm-name" {
  type    = string
  default = "ubuntu-server-packer-2004"
}

variable "vsphere-datacenter" {
  type    = string
  default = "Stack Uno"
}

variable "vsphere-datastore" {
  type    = string
  default = "nuc03-data"
}

variable "vsphere-host" {
  type    = string
  default = "nuc03.home"
}

variable "vsphere-network" {
  type    = string
  default = "VM Network"
}

variable "vsphere-password" {
  type    = string
  default = "password"
}

variable "vsphere-server" {
  type    = string
  default = "vcenter.home"
}

variable "vsphere-user" {
  type    = string
  default = "administrator@vsphere.local"
}


source "vsphere-iso" "autogenerated_1" {
  CPUs                 = 1
  RAM                  = 1024
  RAM_reserve_all      = false
  boot_command         = ["<enter><wait2><enter><wait><f6><esc><wait>", " autoinstall<wait2> ds=nocloud;", "<wait><enter>"]
  boot_wait            = "2s"
  cd_files             = ["./http/user-data", "./http/meta-data"]
  cd_label             = "cidata"
  convert_to_template  = true
  datacenter           = "${var.vsphere-datacenter}"
  datastore            = "${var.vsphere-datastore}"
  disk_controller_type = ["pvscsi"]
  guest_os_type        = "ubuntu64Guest"
  host                 = "${var.vsphere-host}"
  insecure_connection  = "true"
  iso_paths            = ["${var.iso_url}"]
  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }
  notes                  = "Build via Packer"
  password               = "${var.vsphere-password}"
  shutdown_command       = "echo 'ubuntu'|sudo -S shutdown -P now"
  ssh_handshake_attempts = "100"
  ssh_password           = "password"
  ssh_timeout            = "20m"
  ssh_username           = "ubuntu"
  storage {
    disk_size             = 15000
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere-user}"
  vcenter_server = "${var.vsphere-server}"
  vm_name        = "${var.vm-name}"
}


build {
  sources = ["source.vsphere-iso.autogenerated_1"]

  provisioner "shell" {
    inline = ["sudo apt update && sudo apt upgrade -y"]
  }

}
