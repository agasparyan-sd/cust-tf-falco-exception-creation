
# Get Rule
data "sysdig_secure_rule_falco" "this" {
  # Get Managed rule
  name = "${var.rule_name}"
}

# Duplicate Managed Rule 
resource "sysdig_secure_rule_falco" "this" {
  count = var.env != "prod" ? 1 : 0
  name = "${data.sysdig_secure_rule_falco.this.name}_${var.env}"
  description = "Dev"
  condition = data.sysdig_secure_rule_falco.this.condition
  tags = []
  priority = "notice"
  output = "foo"
  source = "syscall"

  dynamic "exceptions" {
    for_each = data.sysdig_secure_rule_falco.this.exceptions
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

#Create Custom Policy for Dev
resource "sysdig_secure_custom_policy" "this" {
  count = var.env != "prod" ? 1 : 0
  name = "Test Policy for ${data.sysdig_secure_rule_falco.this.name}"
  description = "Test policy for ${data.sysdig_secure_rule_falco.this.name}"
  severity = 4
  enabled = true
  runbook = "https://runbook.com"

  // Scope selection
  #scope = "container.id != \"\""
  scope = var.test_policy_scope

  // Rule selection

  rules {
    name = sysdig_secure_rule_falco.this[0].name
    enabled = true
  }
}