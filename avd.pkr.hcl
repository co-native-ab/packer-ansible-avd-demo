packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "2.1.4"
    }
    ansible = {
      version = "1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "build_resource_group_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "managed_image_resource_group_name" {
  type = string
}

source "azure-arm" "this" {
  azure_tags = {
    foo = "bar"
  }
  build_resource_group_name         = var.build_resource_group_name
  use_azure_cli_auth                = true
  communicator                      = "winrm"
  image_offer                       = "Windows-11"
  image_publisher                   = "MicrosoftWindowsDesktop"
  image_sku                         = "Win11-23H2-AVD"
  managed_image_name                = "avd-image-{{isotime `20060102030405`}}"
  managed_image_resource_group_name = var.managed_image_resource_group_name
  os_type                           = "Windows"
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  vm_size                           = "Standard_D4s_v3"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.this"]

  provisioner "powershell" {
    script = "./ConfigureRemotingForAnsible.ps1"
  }

  provisioner "ansible" {
    playbook_file      = "./avd-playbook.yaml"
    use_proxy          = false
    skip_version_check = false
    user               = "packer"
    extra_arguments = [
      "-e ansible_winrm_server_cert_validation=ignore"
    ]
  }
}