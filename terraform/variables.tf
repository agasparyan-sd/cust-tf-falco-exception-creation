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