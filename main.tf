terraform {
  required_version = ">= 1.4.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

# 1. Generate an unknown-at-plan-time sensitive secret
resource "random_password" "db_password" {
  length  = 20
  special = true
}
# 2. Pack the unknown secret into a sensitive map
resource "terraform_data" "db_credentials" {
  input = sensitive({
    username      = "admin"
    secret_token  = random_password.db_password.result
    endpoint_port = 5432
  })
}
