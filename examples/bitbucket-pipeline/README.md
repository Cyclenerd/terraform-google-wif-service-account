# Bitbucket Pipelines

The following example shows you how to configure Workload Identity Federation via Terraform IaC for a Bitbucket pipeline.

## Example

With this example the following steps are executed and configured:

1. Create Workload Identity Pool Provider for Bitbucket
1. Create new service account for Bitbucket pipeline
1. Allow login via Workload Identity Provider and limit login only from the Bitbucket repository (UUID)
1. Output the Workload Identity Pool Provider resource name for Bitbucket pipeline configuration

> An example of a working Bitbucket pipeline configuration (`bitbucket-pipelines.yml`) can be found on [Bitbucket](https://bitbucket.org/cyclenerd/google-workload-identity-federation-for-bitbucket/src/master/bitbucket-pipelines.yml).

<!-- BEGIN_TF_DOCS -->

```hcl
# Create Workload Identity Pool Provider for Bitbucket
module "bitbucket-wif" {
  source            = "Cyclenerd/wif-bitbucket/google"
  version           = "~> 2.0"
  project_id        = var.project_id
  issuer_uri        = var.bitbucket_issuer_uri
  allowed_audiences = var.bitbucket_allowed_audiences
}

# Create new service account for Bitbucket
resource "google_service_account" "bitbucket" {
  project      = var.project_id
  account_id   = var.bitbucket_account_id
  display_name = "Bitbucket pipeline (WIF)"
  description  = "Service Account for Bitbucket pipeline ${var.bitbucket_repository} (Terraform managed)"
}

# Allow service account to login via WIF and only from Bitbucket repository (UUID)
module "bitbucket-service-account" {
  source     = "Cyclenerd/wif-service-account/google"
  version    = "~> 1.1"
  project_id = var.project_id
  pool_name  = module.bitbucket-wif.pool_name
  account_id = google_service_account.bitbucket.account_id
  repository = var.bitbucket_repository
  depends_on = [google_service_account.bitbucket]
}

# Get the Workload Identity Pool Provider resource name for Bitbucket pipeline configuration
output "bitbucket-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.bitbucket-wif.provider_name
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_account_id"></a> [bitbucket\_account\_id](#input\_bitbucket\_account\_id) | The account id of the service account for Bitbucket | `string` | n/a | yes |
| <a name="input_bitbucket_allowed_audiences"></a> [bitbucket\_allowed\_audiences](#input\_bitbucket\_allowed\_audiences) | The Bitbucket allowed audiences | `list(string)` | n/a | yes |
| <a name="input_bitbucket_issuer_uri"></a> [bitbucket\_issuer\_uri](#input\_bitbucket\_issuer\_uri) | The Bitbucket identity provider URL | `string` | n/a | yes |
| <a name="input_bitbucket_repository"></a> [bitbucket\_repository](#input\_bitbucket\_repository) | The Bitbucket repository (UUID) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bitbucket-workload-identity-provider"></a> [bitbucket-workload-identity-provider](#output\_bitbucket-workload-identity-provider) | The Workload Identity Provider resource name |
<!-- END_TF_DOCS -->
