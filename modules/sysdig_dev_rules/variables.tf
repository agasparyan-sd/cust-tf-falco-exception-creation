variable "rule_name" {
    type = string
    description = "Name of the Falco Rule"
}

variable "test_policy_scope" {
    type = string
    description = "Reference: https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_custom_policy"
}

variable "env" {
    type = string
    default = "dev"
    description = "Environment"
}

