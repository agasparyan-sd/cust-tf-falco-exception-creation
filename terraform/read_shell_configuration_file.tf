module "prepare_for_new_exception" {
  source = "../modules/sysdig_dev_rules"
  env = "${terraform.workspace}"
  rule_name = "Read Shell Configuration File" // CHANGE
  test_policy_scope = "container.id != \"\""
}

# Add custom exception to newly created rule
resource "sysdig_secure_rule_falco" "add_custom_exception_1" { // Resource Name Must be Unique across files in the project
  #if workspace is dev ad _dev to end of rulename - othewise its just rulname
  name = "${terraform.workspace}" != "prod" ? module.prepare_for_new_exception.generated_rule_name : module.prepare_for_new_exception.rule_name
  append = true
  exceptions {
    name   = "my_custom_exception_1" // CHANGE
    fields = ["proc.name"]
    comps  = ["in"]
    values = jsonencode([[["python", "python2", "python3"]]]) # If only one element is provided, it should still needs to be specified as a list of lists.
  }
}