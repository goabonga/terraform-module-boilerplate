resource "null_resource" "this" {
  triggers = {
    name = var.name
  }
}
