
# Get Rule
data "sysdig_secure_rule_falco" "managed_rule" {
  # Get Managed rule
  name = "${var.rule_name}"
}

# Duplicate Managed Rule 
resource "sysdig_secure_rule_falco" "custom_dev_rule" {
  name = "${data.sysdig_secure_rule_falco.managed_rule.name}_${terraform.workspace}"
  description = "Dev"
  condition = data.sysdig_secure_rule_falco.managed_rule.condition
  tags = []
  priority = "notice"
  output = "foo"
  source = "syscall"

  dynamic "exceptions" {
    for_each = data.sysdig_secure_rule_falco.managed_rule.exceptions
    content {
      name = exceptions.value.name
      fields = exceptions.value.fields
      comps = exceptions.value.comps
      values = exceptions.value.values != "null" ? jsonencode([[jsondecode(exceptions.value.values)]]) : jsonencode([])
    }
  }
}


# Get info from a Custom Policy - Figure out how to write scoping
#data "sysdig_secure_custom_policy" "example" {
#  name                 = "Access Cryptomining Network"
#  type                 = "falco"
#}

# Create Custom Policy for Dev
# resource "sysdig_secure_custom_policy" "dev_policy" {
#   name = "Dev Scoped Policy"
#   description = "Dev Specific Policy for testing a new rule"
#   severity = 4
#   enabled = true
#   runbook = "https://runbook.com"

#   // Scope selection
#   #scope = "container.id != \"\""
#   scope = "kubernetes.cluster.name in (\"DEV CLUSTER\")"

#   // Rule selection

#   rules {
#     name = sysdig_secure_rule_falco.custom_dev_rule.name
#     enabled = true
#   }
# }