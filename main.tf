terraform {
  required_version = ">= 1.4.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

locals {
  users = {
    "name.surname" = "user1"
    "alice.smith"  = "user2"
    "bob.jones"    = "user3"
  }
}

# Resources with string map index keys:
# - terraform_data.users["name.surname"]
# - terraform_data.users["alice.smith"]
# - terraform_data.users["bob.jones"]
resource "terraform_data" "users" {
  for_each = local.users

  input = {
    username = each.key
    role     = each.value
  }
}

# Another resource with string index key
resource "random_pet" "user_pet" {
  for_each = local.users

  length = 2
  prefix = each.key
}

# Standalone resource without index
resource "terraform_data" "standalone" {
  input = "standard-resource"
}
