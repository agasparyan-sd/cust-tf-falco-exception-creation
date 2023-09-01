module "read_shell_configuration_file" { // CHANGE
  source = "../modules/sysdig_dev_rules"
  env = "${terraform.workspace}"
  rule_name = "Read Shell Configuration File" // CHANGE
  test_policy_scope = "container.id != \"\""
}

# Add custom exception to newly created rule
resource "sysdig_secure_rule_falco" "exception_proc_python" { // CHANGE
  name = "${terraform.workspace}" != "prod" ? module.read_shell_configuration_file.generated_rule_name : module.read_shell_configuration_file.rule_name // CHANGE
  append = true
  exceptions {
    name   = "exception_proc_python" // CHANGE
    fields = ["proc.name"]
    comps  = ["in"]
    values = jsonencode([[["python", "python2", "python3"]]]) # If only one element is provided, it should still needs to be specified as a list of lists.
  }
}