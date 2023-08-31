provider "sysdig" {
  sysdig_secure_url="https://us2.app.sysdig.com"
  sysdig_secure_api_token = "${var.sysdig_secure_token}"
}