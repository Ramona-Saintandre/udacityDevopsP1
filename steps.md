1. Login - `az login`  
2. Verify subscription -`az account show`  
3. Set subscription - `az account set -s "subscription name"`  
4. Create Terraform **config file** `code main.tf`  
    a. create the **provider block** 
    b. create the **resource block**
    
5. Save `main.tf`  
6. **Initialize** the configuration **`#terraform init`**    
7. **Run** the config file to see the output - **`terraform plan`**    
8. **Deploy** the config file - **`terraform deploy`**    
    a. Terraform state file will be created -**`terraform.tfstate`** this is used by Terraform to keep track of changes that has been made or needs to make. 
    b. Display the contents of the state file **` cat terraform.state`**  
    c. Now continue to create the **`main.tf`**
9. Modify Terraform **main.tf**  
    a. Create the **virtual network block**  
    b.  Create the **subnet block**  
    c.  Create the **public IP**   
    d.  Create the **network security group and rule**      
    e. Create the **NIC** -(network interface card)  

 Delete the resource **`terraform destroy`**