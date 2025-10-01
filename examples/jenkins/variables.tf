variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "jenkins_account_id" {
  type        = string
  description = "The account id of the service account for Jenkins"
}

variable "jenkins_build_url" {
  type        = string
  description = "The Jenkins build URL"
}