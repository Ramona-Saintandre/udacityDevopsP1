1. Login - `az login`  
2. Verify subscription -`az account show`  
3. Set subscription - `az account set -s "subscription name"`  
4. Create Terraform **config file** `code main.tf`  
    a. create the **provider block** 
    `provider "azurerm" { `
    `version = "1.38.0"    }`    
    b. create the **resource block**
    `resource :azurerm_resource_group" "rg" { `
    `name = "UdacityP1" `
    `location = "eastus"}`    
5. Save `main.tf`  
6. **Initialize** the configuration **`#terraform init`**    
7. **Run** the config file to see the output - **`terraform plan`**    
8. **Deploy** the config file - **`terraform deploy`**    
   a. Terraform state file will be created -**`terraform.tfstate`** this is used by Terraform to keep track of changes that has been made or needs to make. 
   b. Display the contents of the state file **` cat terraform.state`**  
   c. Now continue to create the **`main.tf`**
9. Create the **virtual network block**  
``resource "azurerm_virtual_network" "vnet" {
  name = "UdacityP1vnet"
 address_space = ["10.0.0.0/16"] 
   location = "eastus"
   resource_group_name = azurerm_resource_group.rg.name`
   }``   

10. Create the **subnet block**  
   `resource "azurerm_subnet" "subnet" {`
   `name = "UdacityP1subnet"` 
   `resource_group_name = azurerm_resource_group.rg.name`  
   `virtual_network_name = azurerm_virtual_network.vnet.name`  
   `address_prefix = "10.0.0.0/24"`
   `}`  
 11. Create the **public IP**   
   ``resource "azurerm_public_ip" "UdacityP1pip" {
   name = "UdacityP1pip"
   location = "eastus"` 
   resource_group_name = azurerm_resource_group.rg.name     
   Allocation_method = "Static"  
   }``  


12. Create the **network security group and rule**      
`resource "azurerm_network_security_group" "nsg" {`
  `name                = "nsg-sshallow-001 "`
  `location            = "westus2"`
  `resource_group_name = azurerm_resource_group.rg.name`

  **`security_rule {`** 
    `name                       = "SSH"`  
    `priority                   = 1001`  
    `direction                  = "Inbound"`  
    `access                     = "Allow"`  
    `protocol                   = "Tcp"`  
    `source_port_range          = "*"`  
    `destination_port_range     = "22"`  
    `source_address_prefix      = "*"`  
    `destination_address_prefix = "*"`  
  `}`  

13. Create the **NIC** -(network interface card)  
    
    ``resource "azurerm_network_interface" "nic01" {
    name  = "UdacityP1_nic01 "  
    location = "eastus"  
    resource_group_name = azurerm_resource_group.rg.name  
    network_security_group_id = azurerm_network_security_group.nsg.id   
    ip_configuration {  
    name = "UdacityP1_ipconfig"  
    subnet_id = azurerm_subnet.subnet.id  
    private_ip_address_allocation = "dynamic"  
   public_ip_address_id = azurerm_public_ip.publicip.id  
  }  
}``  

 Delete the resource **`terraform destroy`**