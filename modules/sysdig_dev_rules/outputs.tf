output "rule_name" {
  value = data.sysdig_secure_rule_falco.this.name
}

output "generated_rule_name" {
  value = "${terraform.workspace}" != "prod" ? sysdig_secure_rule_falco.this[0].name : ""
}