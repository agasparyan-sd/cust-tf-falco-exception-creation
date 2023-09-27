Process:

Inject the Secure Token to github run environments as a Secret 
- Example
export SYSDIG_SECURE_API_TOKEN=<token>

Inject the Secure Sysdig URL to github run environments as a Secret
- Example
export SYSDIG_SECURE_URL=https://us2.app.sysdig.com

Create 2 Workspaces
terraform workspace new prod
terraform workspace new dev

Example of New Managed Rule Exception Testing
Example Rule: Read Shell Configuration File
filename: read_shell_configuration_file.tf
Notice the follwing changes need to be done for every new rule file.
- module "read_shell_configuration_file" { // CHANGE
- rule_name = "Read Shell Configuration File" // CHANGE
- name = "${terraform.workspace}" != "prod" ? module.read_shell_configuration_file.generated_rule_name : module.read_shell_configuration_file.rule_name // CHANGE
- name   = "exception_proc_python" // CHANGE

Once all of the values have been changed.

Run
terraform init
terraform apply

When process completes 
- you should have a custom Rule called Read Shell Configuration File_dev
- you should have a custom Exception appended to Read Shell Configuration File_dev called exception_proc_python

Test your new Exception.
Once testing is complete

Run
terraform destroy

This will clear all of the changes previosly done.

Switch workspace to prod 
terraform workspace select prod

Run
terraform init
terraform apply

Your new tested exception will now apply to the original Read Shell Configuration File rule.



