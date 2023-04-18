/**
 * Copyright 2023 Nils Knieling
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# GOOGLE PROJECT

variable "project_id" {
  type        = string
  description = "The ID of the project"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Invalid project ID!"
  }
}

# IDENTITY POOL

variable "pool_name" {
  type        = string
  description = "The resource name of the Workload Identity Pool"
}

# SERVICE ACCOUNT

variable "account_id" {
  type        = string
  description = "The account id of the existing service account"
  validation {
    condition     = length(regex("([a-z0-9-]{6,30})", var.account_id)) == 1
    error_message = "The 'account_id' value should be 6-30 characters, and may contain the characters [a-z0-9-]."
  }
}

# REPOSITORY

variable "repository" {
  type        = string
  description = "Repository patch (i.e. 'Cyclenerd/google-workload-identity-federation')"
}

# SUBJECT
# GitHub: repo:username/reponame:ref:refs/heads/main
# GitLab: project_path:username/reponame:ref_type:branch:ref:main

variable "subject" {
  type        = string
  description = "Subject (i.e. 'repo:username/reponame:ref:refs/heads/main')"
  default     = null
}