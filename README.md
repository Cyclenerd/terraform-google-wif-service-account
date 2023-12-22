# Allow Login via WIF for Service Accounts

[![Badge: Google Cloud](https://img.shields.io/badge/Google%20Cloud-%234285F4.svg?logo=google-cloud&logoColor=white)](https://github.com/Cyclenerd/terraform-google-wif-service-account#readme)
[![Badge: Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?logo=terraform&logoColor=white)](https://github.com/Cyclenerd/terraform-google-wif-service-account#readme)
[![Badge: CI](https://github.com/Cyclenerd/terraform-google-wif-service-account/actions/workflows/ci.yml/badge.svg)](https://github.com/Cyclenerd/terraform-google-wif-service-account/actions/workflows/ci.yml)
[![Badge: GitHub](https://img.shields.io/github/license/cyclenerd/terraform-google-wif-service-account)](https://github.com/Cyclenerd/terraform-google-wif-service-account/blob/master/LICENSE)

With this Terraform module you can allow login via Google Cloud Workload Identity Pool and Provider for Google Cloud service accounts.
Works best together with the Terraform modules for [GitHub Actions](https://github.com/Cyclenerd/terraform-google-wif-github) and [GitLab CI](https://github.com/Cyclenerd/terraform-google-wif-gitlab).

Service account keys are a security risk if compromised.
Avoid service account keys and instead use the [Workload Identity Federation](https://github.com/Cyclenerd/google-workload-identity-federation#readme).
For more information about Workload Identity Federation and how to best authenticate service accounts on Google Cloud, please see my GitHub repo [Cyclenerd/google-workload-identity-federation](https://github.com/Cyclenerd/google-workload-identity-federation#readme).

## Example

Create Workload Identity Pool and Provider:

```hcl
# Create Workload Identity Pool Provider for GitHub
module "github-wif" {
  source     = "Cyclenerd/wif-github/google"
  version    = "~> 1.0.0"
  project_id = "your-project-id"
}

# Get the Workload Identity Pool Provider resource name for GitHub Actions configuration
output "github-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.github-wif.provider_name
}
```

> Terraform module [`Cyclenerd/wif-github/google`](https://github.com/Cyclenerd/terraform-google-wif-github) is used.

Allow service account to login via Workload Identity Provider and limit login only from the GitHub repo `octo-org/octo-repo`:

```hcl
# Get existing service account for GitHub Actions
data "google_service_account" "github" {
  project    = "your-project-id"
  account_id = "existing-account-for-github-action"
}

# Allow service account to login via WIF
module "github-service-account" {
  source     = "Cyclenerd/wif-service-account/google"
  version    = "~> 1.0.0"
  project_id = "your-project-id"
  pool_name  = module.github-wif.pool_name
  account_id = data.google_service_account.github.account_id
  repository = "octo-org/octo-repo"
}
```

You can secure it even more by using the subject (`attribute.sub`).
This example checks the subject and only allows login from the `prod` environment:
```hcl
# Allow service account to login via WIF
module "github-service-account" {
  source     = "Cyclenerd/wif-service-account/google"
  version    = "~> 1.0.0"
  project_id = "your-project-id"
  pool_name  = module.github-wif.pool_name
  account_id = data.google_service_account.github.account_id
  repository = "octo-org/octo-repo"
  subject    = "repo:octo-org/octo-repo:environment:prod"
}
```

👉 [**More examples**](https://github.com/Cyclenerd/terraform-google-wif-service-account/tree/master/examples)

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.61.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account id of the existing service account | `string` | n/a | yes |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | The resource name of the Workload Identity Pool | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository patch (i.e. 'Cyclenerd/google-workload-identity-federation') | `string` | n/a | yes |
| <a name="input_subject"></a> [subject](#input\_subject) | Subject (i.e. 'repo:username/reponame:ref:refs/heads/main') | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

All files in this repository are under the [Apache License, Version 2.0](LICENSE) unless noted otherwise.