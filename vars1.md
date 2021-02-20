variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "UdacityP1"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
  default     = "UdacityP1"
}


variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     = "UdacityP1"
}

variable "image" {
    description = "The name of the Packer image used"
    default     = "PackerServerImage"
}
variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}


variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}
variable "admin_username" {
  description = "Username to sign into your vms"
  default     = "thenewmona"
}

variable "admin_password" {
  description = "The password to sign into your vms"
  default     = "UdacityDevops2021"
}

variable "application_port" {
  description = "The port that will be exposed to the loadbalancer"
  default     = 80
}

# Azure subscription vars
subscription_id = "1d53902c-4bc6-44c8-82da-d1a59f04c098"
client_id = "129af8a1-a479-4e19-8e7a-10a633a172e6"
client_secret = "IF79ZP2xDzyR~tbfKEOAFAf72Kdmrsb8Sb"
tenant_id = "38e23809-f428-4d08-9f4e-b3b8b2df585c"

# Resource Group/Location
location = "eastus"
resource_group = "UdacityP1"
application_type = "webApp"

# Network
address_space = ["10.5.0.0/16"]
address_prefix_test = "10.5.1.0/24"

packer_image_id =  "/subscriptions/1d53902c-4bc6-44c8-82da-d1a59f04c098/resourceGroups/UdacityP1/providers/Microsoft.Compute/images/PackerServerImage"
vm_count = 2

