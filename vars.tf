//[Building Azure Infrastructure with Terraform](https://www.youtube.com/watch?v=d6EOEXxMZ8w)
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "UdacityP1"
}
# variable "azurerm_resource_group""image" {
#   description = "The resource group where image will be deployed"
#   default = "PackerServerImage"
  
# }
variable "servername" {
  type        = string
  description = "Server name of the virtual machine"
  default     = "UdacityP1-Linux"
}
variable "image" {
    description = "The name of the Packer image used"
    default     = "PackerServerImage"
}
variable  "azurerm_image"  {
  description = "Image to be used "
  default = "PackerResourceGroup"
}

variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     = "PackerServerImage"
}
variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
  default     = "UdacityP1"
}
variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}

variable "admin_username" {
  description = "The username to sign into your vms"
  default     = "thenewmona"
}
variable "admin_password" {
  type        = string
  description = "Administrator password for server"
  default     = "P@$$w0rd1"
}

variable "vnet_address_space" {
  type        = list(any)
  description = "Address space for Virtual Network"
  default     = ["10.0.0.0/16"]
}

variable "application_port" {
    type 	  = string
    description = "The port that you want to expose to the external load balancer"
    default     = 80
}
variable "managed_disk_type" {
  type        = map(any)
  description = "Disk type Premium in Primary location Standard in DR location"

  default = {
    westus2 = "Premium_LRS"
    eastus  = "Standard_LRS"
  }
}
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}
variable "vm_size" {
  type        = string
  description = "Size of VM"
  default     = "Standard_B1s"
}
# variable "packerImageId"{
#   default = "/subscriptions/1d53902c-4bc6-44c8-82da-d1a59f04c098/resourceGroups/UdacityP1/providers/Microsoft.Compute/images/PackerServerImage"
# }


    