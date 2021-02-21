1. <font color=#0000CC>**Login**</font> -<font color=#009966>***`az login`***</font>
2. <font color=#0000CC>**Verify subscription**</font> -<font color=#009966>***`az account show`***</font>  
3. <font color=#0000CC>**Set subscription**</font> - <font color=#009966>***`az account set -s "subscription name"`***  </font>
4. <font color=#0000CC>**Create**: 
 </font> Terraform **config file** <font color=#009966>***`code main.tf`*** </font>   
    a. create the **provider block**   
    b. create the **resource block**  

 <font color=#FF0000>**Note**</font>: 
You can run <font color=#009966> ***`teraform mft`***</font> to make sure that your file is formatted correctly.
 This is like `prettier`

5. <font color=#0000CC>**Save**</font> `main.tf`  
6. **Initialize** the configuration <font color=#009966>***`terraform init`***</font>
   
  <font color=#FF0000>**Note**</font>: After running ***`Terraform init`*** a ***`.terraform`***  file is created.  
   <font color=#FF0005>*Add*</font> this to you <font color=#FF0005>***`.gitignore`***</font>  file.  
   Otherwise you will have issues with version control. 

7. <font color=#0000CC>**Run**</font> the config file to see the output - <font color=#009966>***`terraform plan -out`*** </font>   
   a. Doing `terraform plan` is a way to review, and validate your code and configuration before you check in, and deploy   
   b. adding the `-out` creates a output file     
<font color=#FF0000>**Note**</font>: `-out` is required for the project  

8. <font color=#0000CC> **Deploy**</font> the config file - <font color=#009966>***`terraform deploy`***</font>   
    a. Terraform state file will be created -**`terraform.tfstate`** this is used by Terraform to keep track of changes that has been made or needs to make. 
    b. Display the contents of the state file <font color=#009966>**` cat terraform.state`**</font>  
    c. Now continue to modify the **`main.tf`**
9.  <font color=#0000CC>**Modify**</font> Terraform **`main.tf`**  
    a. Create the **virtual network block**  
    b.  Create the **subnet block**  
    c.  Create the **public IP**   
    d.  Create the **network security group and rule**      
    e. Create the **NIC** -(network interface card)  

10. <font color=#0000CC>**Apply**</font> Your configuration to your **Azure** subscription by running   </font>  <font color=##009966>***`terraform apply`***</font>  
    a. You should now have a **`terraform.tfstate`** file  
<font color=#FF0000>**Note**:</font>  Whenever you run 
***`terraform apply`***  from now on you will get a **`terraform.tfstate.backup`** file keeping the original untouched.    
<font color=#FF0000>**Note**</font>: ***`terraform apply -auto -approve`*** can be used if you don't have a state file 
11.  <font color=#0000CC>**Run**</font> <font color=##009966>***`terraform show`***</font> to view your state file 
    
12.  <font color=#0000CC> **Delete**</font> the resource by running
 <font color=##009966>***`terraform destroy`***</font>

<font color=#FF0000>**Note**:</font>  
This is not a best practice, but if you are working on a team, you may have somone else make changes. 
This is known as **State Drift**,  
You can do a `terraform refresh`  if you or someone else make changes outside **Terraform**.
This will make sure that you are working with the latest 