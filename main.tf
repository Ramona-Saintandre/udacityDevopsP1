provider "azurerm" {
   features {}
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "main" {
 name     = "${var.prefix}"
 location = "${var.location}"
 tags = {
  webserver-env = "udacityProject"
 }
}

resource "azurerm_virtual_network" "main" {
 name                = "${var.prefix}-net"
 address_space       = "${var.address_space}"
 location            = azurerm_resource_group.main.location
 resource_group_name = azurerm_resource_group.main.name
 tags = {
  webserver-env = "udacityProject"
 }
}

resource "azurerm_subnet" "main" {
 name                 = "${var.prefix}-subnet"
 resource_group_name  = azurerm_resource_group.main.name
 virtual_network_name = azurerm_virtual_network.main.name
 address_prefixes       = "${var.address_prefix_main}"
}

resource "azurerm_public_ip" "main" {
 name                         =  "${var.prefix}-pubIP"
 location                     = azurerm_resource_group.main.location
 resource_group_name          = azurerm_resource_group.main.name
 allocation_method            = "Static"
 tags = {
    webserver-env = "udacityProject"
 }
}

resource "azurerm_network_security_group" "main" {
    name                =  "${var.prefix}-netsecgrp"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    security_rule {
        name                       = "Internet"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = {
         webserver-env = "udacityProject"
    }
}

resource "azurerm_lb" "main" {
 name                = "${var.prefix}-lb"
 location            = azurerm_resource_group.main.location
 resource_group_name = azurerm_resource_group.main.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.main.id
 }

 tags = {
  webserver-env = "udacityProject"
 }
}

resource "azurerm_lb_backend_address_pool" "main" {
 resource_group_name = azurerm_resource_group.main.name
 loadbalancer_id     = azurerm_lb.main.id
 name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "main" {
 count               = "${var.vm_count}"
 name                = "acctni${count.index}"
 location            = azurerm_resource_group.main.location
 resource_group_name = azurerm_resource_group.main.name

 ip_configuration {
   name                          = "mainConfiguration"
   subnet_id                     = azurerm_subnet.main.id
   private_ip_address_allocation = "dynamic"
 }
 tags = {
  webserver-env = "udacityProject"
 }
}

resource "azurerm_network_interface_security_group_association" "example" {
    count               = "${var.vm_count}"
    network_interface_id      = azurerm_network_interface.main[count.index].id
    network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_managed_disk" "main" {
 count                = "${var.vm_count}"
 name                 = "datadisk_existing_${count.index}"
 location             = azurerm_resource_group.main.location
 resource_group_name  = azurerm_resource_group.main.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "10"
 tags = {
  webserver-env = "udacityProject"
 }
}


data "azurerm_image" "image" {
  name                = "PackerServerImage"
  resource_group_name = "UdacityP1"
}

output "image_id" {
  value = "${var.packer_image_id}"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = azurerm_resource_group.main.location
 resource_group_name          = azurerm_resource_group.main.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
 tags = {
  webserver-env = "udacityProject"
 }
}

resource "azurerm_virtual_machine" "main" {
 count                 = "${var.vm_count}"
 name                  = "acctvm${count.index}"
 location              = azurerm_resource_group.main.location
 availability_set_id   = azurerm_availability_set.avset.id
 resource_group_name   = azurerm_resource_group.main.name
 network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
 vm_size               = "Standard_B1s"

 storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "10"
 }

 storage_data_disk {
   name            = element(azurerm_managed_disk.main.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.main.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.main.*.disk_size_gb, count.index)
 }

 os_profile {
   computer_name  = "hostname${count.index}"
   admin_username = ""
   admin_password = ""
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }
 tags = {
  webserver-env = "UdacityP1",
  "dept"="deployment"
 }
}