packer {
  required_plugins {
    ibmcloud = {
      version = ">=v3.0.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}

variable "ibm_api_key" {
  type = string
  default = "${env("IBM_API_KEY")}"
}

variable "ibm_region" {
  type = string
  default = "us-south"
}

variable "resource_group_id" {
  type = string
  default = "${env("RESOURCE_GROUP_ID")}"
}

variable "subnet_id" {
  type = string
  default = "${env("SUBNET_ID")}"
}

variable "security_group_id" {
  type = string
  default = "${env("SECURITY_GROUP_ID")}"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "starter-${local.timestamp}"
}

source "ibmcloud-vpc" "starter" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "${var.subnet_id}"
  resource_group_id  = "${var.resource_group_id}"
  security_group_id  = "${var.security_group_id}"
  vsi_base_image_id  = "r006-4861e0a4-8d36-4462-b497-767351f1d371"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = ""

  image_name   = "${local.name}"
  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

build {
  name = "vpc-packer-builder"
  sources = [
    "source.ibmcloud-vpc.starter"
  ]

  provisioner "file" {
    source      = "./init.sh"
    destination = "/opt/init.sh"
  }

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    environment_vars = [
      "REGION=${var.ibm_region}",
      "PACKER_TEMPLATE=${local.name}"

    ]
    inline = [
      "chmod +x /opt/init.sh",
      "/opt/init.sh"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}



