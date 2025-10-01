# Jenkins

The following example shows you how to configure Workload Identity Federation via Terraform IaC for Jenkins with the [OpenID Connect Provider plugin](https://plugins.jenkins.io/oidc-provider/).

## Example

With this example the following steps are executed and configured:

1. Create Workload Identity Pool Provider for Jenkins
1. Create new service account for Jenkins
1. Allow login via Workload Identity Provider and limit login only from specific Jenkins build with URL in subject
1. Output the Workload Identity Pool Provider resource name for Jenkins configuration

<!-- BEGIN_TF_DOCS -->

```hcl
# Create Workload Identity Pool Provider for Jenkins
module "jenkins-wif" {
  source            = "Cyclenerd/wif-jenkins/google"
  version           = "~> 1.0"
  project_id        = var.project_id
  issuer_uri        = "https://jenkins.localhost"
  allowed_audiences = ["https://jenkins.localhost"]
  # Export of public OIDC JSON Web Key (JWK) file
  jwks_json_file = "jenkins-jwk.json"
}

# Create new service account for Jenkins
resource "google_service_account" "jenkins" {
  project      = var.project_id
  account_id   = var.jenkins_account_id
  display_name = "Jenkins (WIF)"
  description  = "Service Account for Jenkins (Terraform managed)"
}

# Allow service account to login via WIF and only from specific Jenkins build with URL in subject
module "jenkins-service-account" {
  source     = "Cyclenerd/wif-service-account/google"
  version    = "~> 1.1"
  project_id = var.project_id
  pool_name  = module.jenkins-wif.pool_name
  account_id = google_service_account.jenkins.account_id
  subject    = var.jenkins_build_url
  depends_on = [google_service_account.jenkins]
}

# Get the Workload Identity Pool Provider resource name for Jenkins configuration
output "jenkins-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.jenkins-wif.provider_name
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_jenkins_account_id"></a> [jenkins\_account\_id](#input\_jenkins\_account\_id) | The account id of the service account for Jenkins | `string` | n/a | yes |
| <a name="input_jenkins_build_url"></a> [jenkins\_build\_url](#input\_jenkins\_build\_url) | The Jenkins build URL | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jenkins-workload-identity-provider"></a> [jenkins-workload-identity-provider](#output\_jenkins-workload-identity-provider) | The Workload Identity Provider resource name |
<!-- END_TF_DOCS -->
