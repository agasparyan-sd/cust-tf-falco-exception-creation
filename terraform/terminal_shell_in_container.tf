module "terminal_shell_in_container" { // CHANGE
  source = "../modules/sysdig_dev_rules"
  env = "${terraform.workspace}"
  rule_name = "Terminal shell in container" // CHANGE
  test_policy_scope = "container.id != \"\""
}

# Add custom exception to newly created rule
resource "sysdig_secure_rule_falco" "exception_proc_java" { // CHANGE
  name = "${terraform.workspace}" != "prod" ? module.terminal_shell_in_container.generated_rule_name : module.terminal_shell_in_container.rule_name // CHANGE
  append = true
  exceptions {
    name   = "exception_proc_java" // CHANGE
    fields = ["proc.name"]
    comps  = ["in"]
    values = jsonencode([[["java", "java2", "java3"]]]) # If only one element is provided, it should still needs to be specified as a list of lists.
  }
}