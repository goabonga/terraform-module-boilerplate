# terraform-module-boilerplate

Terraform module boilerplate supports CI with GitHub Actions and automatic document generation with [terraform-docs](https://github.com/terraform-docs/terraform-docs).

<!-- BEGIN_TF_DOCS -->
## Examples

```hcl
module "example" {
  source = "../../"

  name = "example"
}

output "name" {
  value = module.example.name
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Resource name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Resource name |
<!-- END_TF_DOCS -->

## Developer Guides

### Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Docker](https://docs.docker.com/get-docker/)

### Run Terraform

The following command run Terraform in the examples/basic directory.

```shell
make plan
make apply
make destroy
```

### Generate document

The following command generate document with terraform-docs.

```shell
make docs
```

### Test module

The following command run test with [terratest](https://terratest.gruntwork.io/).

```shell
make test
```

### Release

Run the following command, and type a new version when asked.

```shell
make bump-version
```

These commands perform the following process.

- Bump version
- Create new tag
- Push release branch

Then you can create a new Pull Request in GitHub, review and merge.

## License

Licensed under the  MIT License.

See [LICENSE](LICENSE) for full details.
