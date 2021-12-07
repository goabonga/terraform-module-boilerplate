module "example" {
  source = "../../"

  name = "example"
}

output "name" {
  value = module.example.name
}
