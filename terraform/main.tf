terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url="https://us2.app.sysdig.com"
  sysdig_secure_api_token = "${var.sysdig_secure_token}"
}

module "prepare_for_new_exception" {
  count = "${terraform.workspace}" == "dev" ? 1 : 0
  source = "../modules/sysdig_dev_rules"
  rule_name = "${var.rule_name}"
}

# Add custom exception to newly created rule
resource "sysdig_secure_rule_falco" "add_custom_exception" {
  #if workspace is dev ad _dev to end of rulename - othewise its just rulname
  name = "${terraform.workspace}" == "dev" ? module.prepare_for_new_exception[0].generated_rule_name : "${var.rule_name}"
  append = true
  exceptions {
    name   = "${var.exception_name}"
    fields = ["proc.name"]
    comps  = ["in"]
    values = jsonencode([[["python", "python2", "python3"]]]) # If only one element is provided, it should still needs to be specified as a list of lists.
  }
}