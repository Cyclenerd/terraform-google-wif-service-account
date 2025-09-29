/**
 * Copyright 2023-2025 Nils Knieling
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

locals {
  attribute = var.subject != null ? "attribute.sub" : "attribute.repository"
  value     = var.subject != null ? var.subject : var.repository
}

# SERVICE ACCOUNT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account

data "google_service_account" "user" {
  project    = var.project_id
  account_id = var.account_id
}

# IAM POLICY FOR SERVICE ACCOUNT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam#google_service_account_iam_binding

resource "google_service_account_iam_binding" "wif-binding" {
  service_account_id = data.google_service_account.user.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${var.pool_name}/${local.attribute}/${local.value}"
  ]
}