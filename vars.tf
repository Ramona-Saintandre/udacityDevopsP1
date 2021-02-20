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
//address_space = ["10.5.0.0/16"]
address_prefix_test = "10.5.1.0/24"

packer_image_id =  "/subscriptions/1d53902c-4bc6-44c8-82da-d1a59f04c098/resourceGroups/UdacityP1/providers/Microsoft.Compute/images/PackerServerImage"
vm_count = 2