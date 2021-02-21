1. Login - `az login`  
2. Verify subscription -`az account show`  
3. Set subscription - `az account set -s "subscription name"`  
4. Create Terraform **config file** `code main.tf`  
    a. create the **provider block** 
    b. create the **resource block**  

 **Note**: 
 ***You can run `teraform mft` to make sure that your file is formatted correctly.
 This is like `prettier`***

5. Save `main.tf`  
6. **Initialize** the configuration **`#terraform init`**  
   
   **Note**: ***After running `Terraform init` a `.terraform` file is created.  
   Add this to you `.gitignore` file.  
   Otherwise you will have issues with version control.*** 
7. **Run** the config file to see the output - **`terraform plan -out`**   
   a. Doing `terraform plan` is a way to review, and validate your code and configuration before you check in, and deploy 
   b. adding the `-out` creates a output file 
**Note**: `-out` is required for the project
8. **Deploy** the config file - **`terraform deploy`**    
    a. Terraform state file will be created -**`terraform.tfstate`** this is used by Terraform to keep track of changes that has been made or needs to make. 
    b. Display the contents of the state file **` cat terraform.state`**  
    c. Now continue to modify the **`main.tf`**
9.  Modify Terraform **`main.tf`**  
    a. Create the **virtual network block**  
    b.  Create the **subnet block**  
    c.  Create the **public IP**   
    d.  Create the **network security group and rule**      
    e. Create the **NIC** -(network interface card)  

10. **Apply** Your configuration to your **Azuare** subscription by running   **`terraform apply`**  
11.  Delete the resource by running **`terraform destroy`**