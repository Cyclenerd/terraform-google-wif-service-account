variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "bitbucket_issuer_uri" {
  type        = string
  description = "The Bitbucket identity provider URL"
}

variable "bitbucket_allowed_audiences" {
  type        = list(string)
  description = "The Bitbucket allowed audiences"
}

variable "bitbucket_repository" {
  type        = string
  description = "The Bitbucket repository (UUID)"
}

variable "bitbucket_account_id" {
  type        = string
  description = "The account id of the service account for Bitbucket"
}