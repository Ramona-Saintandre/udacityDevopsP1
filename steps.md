1. Login - `az login`  
2. Verify subscription -`az account show`  
3. Set subscription - `az account set -s "subscription name"`  
4. Create Terraform **config file** `code main.tf`  
    a. create the **provider block** 
    `provider "azurerm" {         version = "1.38.0"    }`  
    b. create the **resource block**
    `resource :azurerm_resource_group" "rg" { name = "UdacityP1" location = "eastus"}`  
5. Save `main.tf`
6. Initialize the configuration `terraform init`  
7. Run the config file to see the output - `terraform plan`  
8. Deploy the config file - `terraform deploy`  
   a. Terraform state file will be created - `terraform.tfstate` this is used by Terraform to keep track of changes that has been made or needs to make. 
   b. Display the contents of the state file ` cat terraform.state`  
9. Delete the resource `terraform destroy`