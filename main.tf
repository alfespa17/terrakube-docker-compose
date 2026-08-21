terraform {
  required_version = ">= 1.4.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

variable "environment" {
  type        = string
  description = "Target environment name (injected from terragrunt.hcl)"
}

variable "project_name" {
  type        = string
  description = "Project name (injected from terragrunt.hcl)"
}

variable "instance_count" {
  type        = number
  description = "Number of sample resource instances"
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "Tags map passed from Terragrunt"
  default     = {}
}

resource "random_id" "deployment_suffix" {
  byte_length = 4
}

resource "random_password" "generated_token" {
  length  = 16
  special = false
}

resource "terraform_data" "sample_app" {
  count = var.instance_count

  input = {
    app_id      = "${var.project_name}-${var.environment}-${count.index + 1}-${random_id.deployment_suffix.hex}"
    instance_no = count.index + 1
    environment = var.environment
    managed_by  = var.tags["ManagedBy"]
  }
}


output "project_name" {
  value       = var.project_name
  description = "Project name injected via Terragrunt inputs"
}

output "environment" {
  value       = var.environment
  description = "Environment injected via Terragrunt inputs"
}

output "deployment_id" {
  value       = random_id.deployment_suffix.hex
  description = "Unique deployment suffix"
}

output "sample_resources" {
  value       = [for item in terraform_data.sample_app : item.output]
  description = "Resource data outputs resolved from Terragrunt execution"
}

output "secret_token" {
  value       = random_password.generated_token.result
  sensitive   = true
  description = "Sensitive token output to verify sensitivity masking"
}
