resource "google_project_service" "service" {
  service = "iam.googleapis.com" 

  project = var.project 
  disable_on_destroy = false
}

# DP1 Service Account
resource "google_service_account" "service_account-dp-1" {
  account_id   = "dp-1-sa"
  display_name = "Service Account for data product 1"
}

# DP2 Service account
resource "google_service_account" "service_account-dp-2" {
  account_id   = "dp-2-sa"
  display_name = "Service Account for data product 2"
}

# DP1 Output port
resource "google_bigquery_dataset" "dataset-dp-1" {
  dataset_id                  = "dp1ds"
  friendly_name               = "dp1-dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  default_partition_expiration_ms = 5184000000

  access {
    role          = "OWNER"
    user_by_email = google_service_account.service_account-dp-1.email
  }

  access {
    role = "READER"
    user_by_email = google_service_account.service_account-dp-2.email
  }
}

# DP1 Input port
resource "google_storage_bucket" "dp-1-sb" {
  name          = "dp-1-loading-zone"
  location      = "US"
  force_destroy = true
}

# DP1 SP permissions
data "google_iam_policy" "dp-1-admin" {
  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${google_service_account.service_account-dp-1.email}",
    ]
  }

  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:data-mesh-base-infra-provision@data-mesh-demo.iam.gserviceaccount.com",
      "serviceAccount:${google_service_account.service_account-dp-1.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "dp-1-sb-policy" {
  bucket = google_storage_bucket.dp-1-sb.name
  policy_data = data.google_iam_policy.dp-1-admin.policy_data
}

resource "google_storage_bucket_iam_policy" "dp-1-dataflow-temp-sb-policy" {
  bucket = google_storage_bucket.dp-1-dataflow-temp.name
  policy_data = data.google_iam_policy.dp-1-admin.policy_data
}

resource "google_project_iam_member" "dp-1-sa-bq-job-user" {
  project = var.project 
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-1.email}"
}

resource "google_project_iam_member" "dp-1-sa-dataflow-developer" {
  project = var.project 
  role    = "roles/dataflow.developer"
  member  = "serviceAccount:${google_service_account.service_account-dp-1.email}"
}

resource "google_project_iam_member" "dp-1-sa-compute-viewer" {
  project = var.project 
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.service_account-dp-1.email}"
}

resource "google_storage_bucket_iam_member" "df-1-dataflow-temp-admin" {
  bucket = google_storage_bucket.dp-1-dataflow-temp.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:64709029339-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "dp-2-sa-bq-job-user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-2.email}"
}

# DP1 internals
resource "google_storage_bucket" "dp-1-dataflow-temp" {
  name          = "dp-1-df-temp"
  location      = "US"
  force_destroy = true
}

# DP2 output port
resource "google_bigquery_dataset" "dataset-dp-2" {
  dataset_id                  = "dp2ds"
  friendly_name               = "dp2-dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  default_partition_expiration_ms = 5184000000

  access {
    role          = "OWNER"
    user_by_email = google_service_account.service_account-dp-2.email
  }
}
