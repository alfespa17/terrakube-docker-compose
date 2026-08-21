# Terragrunt configuration for Terrakube test

inputs = {
  environment  = "development"
  project_name = "terrakube-terragrunt-demo"
  instance_count = 2
  tags = {
    ManagedBy   = "Terrakube"
    Engine      = "Terragrunt"
    Environment = "Dev"
  }
}
