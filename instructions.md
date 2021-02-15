### Instructions for the Project
1. Login - `az-login`
2. Acquire subscription id - (**the id will be used for the Packer build**) `az account show --query "{subscription_id}`
3. Create a security policy - `az policy definition create --name tagging-policy --mode indexed --rules policy.json`
4. Assign the policy - `az policy definition create --name policy tagging-policy`
5. create a service principal - `az ad sp create-for-rbac --query "{client_id: appId, client_secret: password, tenant_id: tenant}"`
6. create a packer resource group `az create group create -n packerResourceGroup -l eastus`
7. Create and Deploy VM machine image to Azure using Packer - `packer build server.json` (**Set client_id and subsription_id as environment variables in the `server.json` file**)
8. Provision resources using TerraForm 
    * `terraform init`
    * `terraform plan -out solution.plan`
    * `terraform apply "solution.plan"`
    * `terraform destroy`   
### Delete all the Resource 

 * az group delete --name packerResourceGroup --yes
 * az group delete --name NetwrokWatcherRG --yes 
  

