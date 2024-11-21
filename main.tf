# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

module "time_module" {
  source = "./module"
}
 
resource "time_sleep" "wait_30_seconds" {
  
  depends_on = [null_resource.previous]

  create_duration = local.time
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
# } force plan error

output "creation_time" {
    value = time_sleep.wait_30_seconds.create_duration
}
