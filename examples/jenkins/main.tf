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
