variable "rule_name" {
 type = string
 default = "Rule"
 description = "Name of the Falco Rule"
}

variable "exception_name" {
 type = string
 default = "Exception" # any value that is new
 description = "Name of the Falco Rule Exception"
}

variable "sysdig_secure_token" {
 type = string
 default = "<token>" # any value that is new
 description = "Sysdig API Token"
}