# [Building Azure Infrastructure with Terraform](https://www.youtube.com/watch?v=d6EOEXxMZ8w)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
  }
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}

}

# Create resource group
resource "azurerm_resource_group" "PackerResourceGroup" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    "environment" : "PackerResourceGroup"
  }
}

# Create network security group
resource "azurerm_network_security_group" "PackerResourceGroup" {
  name                = "PackerResourceGroup-security-group"
  location            = azurerm_resource_group.PackerResourceGroup.location
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

  # Create virtual network
  resource "azurerm_virtual_network" "PackerResourceGroup" {
    name                = "PackerResourceGroup-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.PackerResourceGroup.name

    tags = {
      "environment" : "PackerResourceGroup"
    }
  }

  # Create subnet
  resource "azurerm_subnet" "PackerResourceGroup" {
    name                 = "PackerResourceGroup-subnet"
    resource_group_name  = azurerm_resource_group.PackerResourceGroup.name
    virtual_network_name = azurerm_virtual_network.PackerResourceGroup.name
    address_prefixes     = ["10.0.2.0/24"]
  }

  # Create public ip address
  resource "azurerm_public_ip" "PackerResourceGroup" {
    # count                   = var.vm_count
    name                    = "PackerResourceGroup-pip"
    location                = var.location
    resource_group_name     = azurerm_resource_group.PackerResourceGroup.name
    allocation_method       = "Static"
    idle_timeout_in_minutes = 30
  
    tags = {
      "environment" = "PackerResourceGroup"
    }
    }
  
# VM security rules
resource "azurerm_network_security_rule" "PackerResourceGroupvm" {
  name                        = "allow_subnet_vm_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/16"
  destination_address_prefix  = "10.0.0.0/16"
  resource_group_name         = azurerm_resource_group.PackerResourceGroup.name
  network_security_group_name = azurerm_network_security_group.PackerResourceGroup.name
}

resource "azurerm_network_security_rule" "blockinternetaccess" {
  name                        = "blockinternetaccess"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.PackerResourceGroup.name
  network_security_group_name = azurerm_network_security_group.PackerResourceGroup.name
}

# Create load balancer
resource "azurerm_lb" "PackerResourceGroup" {
  name                = "PackerResourceGroup-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name

  frontend_ip_configuration {
    name                 = "PublicIpAddress"
    public_ip_address_id = azurerm_public_ip.PackerResourceGroup.id
  }

  tags = {
    "environment" = "PackerResourceGroup"
  }
}

resource "azurerm_lb_backend_address_pool" "PackerResourceGroup" {
  name                = "BackendPool"
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name
  loadbalancer_id     = azurerm_lb.PackerResourceGroup.id
}

resource "azurerm_lb_probe" "PackerResourceGroup" {
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name
  loadbalancer_id     = azurerm_lb.PackerResourceGroup.id
  name                = "ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "PackerResourceGroup" {
  resource_group_name            = azurerm_resource_group.PackerResourceGroup.name
  loadbalancer_id                = azurerm_lb.PackerResourceGroup.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  frontend_ip_configuration_name = "PublicIpAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.PackerResourceGroup.id
  probe_id                       = azurerm_lb_probe.PackerResourceGroup.id
}

##Specify image

data "azurerm_resource_group" "image" {
  name  = "PackerResoureGroup"
}
  data "azurerm_image" "image" {
  name                = var.image
  resource_group_name = data.azurerm_resource_group.image.name
}


# Setup virtual machine availability set and scale set
resource "azurerm_availability_set" "PackerResourceGroup_as" {
  name                = "PackerResourceGroup_as"
  location            = var.location
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name
  managed             = true
}

# Create network interface
resource "azurerm_network_interface" "PackerResourceGroup" {
  count               = var.vm_count
  name                = "PackerResourceGroup-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name

  ip_configuration {
    name                          = "PackerResourceGroup-nic-config"
    subnet_id                     = azurerm_subnet.PackerResourceGroup.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create linux virtual machine
resource "azurerm_linux_virtual_machine" "PackerResourceGroup" {
  count               = var.vm_count
  name                = "PackerResourceGroup-vm-${count.index}"
  resource_group_name = azurerm_resource_group.PackerResourceGroup.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.PackerResourceGroup[count.index].id
  ]
  source_image_id = data.azurerm_image.image.id

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_managed_disk" "PackerResourceGroup-md" {
  count                = var.vm_count
  name                 = "PackerResourceGroup-md_${count.index}"
  resource_group_name  = azurerm_resource_group.PackerResourceGroup.name
  location             = var.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 5
}

resource "azurerm_virtual_machine_data_disk_attachment" "PackerResourceGroup" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.PackerResourceGroup1-md[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.PackerResourceGroup[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}


