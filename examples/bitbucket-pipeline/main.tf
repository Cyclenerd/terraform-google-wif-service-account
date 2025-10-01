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