# Introduction 
This project is an automated solution for deploying Landing Zone in Azure, as per Customer's requirements using Terraform.

# Getting Started

1. Install Az Module in PowerSshell by following the steps here (https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.1.0).
2. Install Terraform by following the steps here(https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli).
3. Install Visual Studio Code from here (https://code.visualstudio.com/)

To Deploy the Landing Zone, we need to update just the Config.tfvars and Deploy.ps1 script, and run the Deploy.ps1 script. (Refer to below section for detail steps)

To Destroy the Landing Zone, we need to update Destroy.ps1 script and make sure .terraform and Modules folders as well as terraform.lock.hcl and landingzone.tfstate, which are created in the process of deployment are available. Finally we run the Destroy.ps1 script. (Refer to below section for detail steps)

# How to Customize, Deploy and Destroy

Deploy:

Step 1: Launch the Visual Studio Code and open the solution folder.

Step 2: Once all the files are visible in Explorer Section, you can start with updating the Landing Zone Subscription ID in Deploy and Destroy Script.

Step 3: Now, update the config.tfvars file with all the details for the resources that should to be deployed. Give special attention to deploy_identity, deploy_gateway and deploy_expressroute variables as the deployment of the specific resource(s) depends on the boolean value set here.

Step 4: Now you are all set to deploy the Landing Zone. Use the terminal (PowerShell) or PowerShell session to set the location to the solution folder and run the Deploy.ps1 script.

Step 5: If the deployment is successful validate the resources in Azure and if any failures are encountered, troubleshoot, apply the changes and rerun the deployment.

Destroy:

Assuming Landing Zone is deployed successfully using above steps and you plan to destroy the Landing Zone follow below steps.

Step 1: Validate Destroy.ps1 script for the Subscription ID and update if necessary.

Step 2: Make sure .terraform and Modules folders as well as terraform.lock.hcl and landingzone.tfstate, which are created in the process of deployment are available. 

Step 3: Finally, run the Destroy.ps1 script to destroy the Landing Zone. 