resource "google_project_service" "service" {
  service = "iam.googleapis.com" 

  project = var.project 
  disable_on_destroy = false
}

# DP1 Service Account
resource "google_service_account" "service_account-dp-a" {
  account_id   = "dp-a-sa"
  display_name = "Service Account for data product A"
}

# DP2 Service account
resource "google_service_account" "service_account-dp-b" {
  account_id   = "dp-b-sa"
  display_name = "Service Account for data product B"
}

# DP1 Output port
resource "google_bigquery_dataset" "dataset-dp-a" {
  dataset_id                  = "dp1ds"
  friendly_name               = "dp1-dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  default_partition_expiration_ms = 5184000000

  access {
    role          = "OWNER"
    user_by_email = google_service_account.service_account-dp-a.email
  }

  access {
    role = "READER"
    user_by_email = google_service_account.service_account-dp-b.email
  }
}

# DP1 Input port
resource "google_storage_bucket" "dp-a-sb" {
  name          = "dp-a-input"
  location      = "US"
  force_destroy = true
}

# DP1 SP permissions
data "google_iam_policy" "dp-a-admin" {
  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${google_service_account.service_account-dp-a.email}",
    ]
  }

  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:data-mesh-base-infra-provision@data-mesh-demo.iam.gserviceaccount.com",
      "serviceAccount:${google_service_account.service_account-dp-a.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "dp-a-sb-policy" {
  bucket = google_storage_bucket.dp-a-sb.name
  policy_data = data.google_iam_policy.dp-a-admin.policy_data
}

resource "google_storage_bucket_iam_policy" "dp-a-dataflow-temp-sb-policy" {
  bucket = google_storage_bucket.dp-a-dataflow-temp.name
  policy_data = data.google_iam_policy.dp-a-admin.policy_data
}

resource "google_project_iam_member" "dp-a-sa-bq-job-user" {
  project = var.project 
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-a.email}"
}

resource "google_project_iam_member" "dp-a-sa-dataflow-developer" {
  project = var.project 
  role    = "roles/dataflow.developer"
  member  = "serviceAccount:${google_service_account.service_account-dp-a.email}"
}

resource "google_project_iam_member" "dp-a-sa-compute-viewer" {
  project = var.project 
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.service_account-dp-a.email}"
}

resource "google_storage_bucket_iam_member" "df-A-dataflow-temp-admin" {
  bucket = google_storage_bucket.dp-a-dataflow-temp.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:64709029339-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "dp-b-sa-bq-job-user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-b.email}"
}

# DP1 internals
resource "google_storage_bucket" "dp-a-dataflow-temp" {
  name          = "dp-a-df-temp"
  location      = "US"
  force_destroy = true
}

# DP2 output port
resource "google_bigquery_dataset" "dataset-dp-b" {
  dataset_id                  = "dp2ds"
  friendly_name               = "dp2-dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  default_partition_expiration_ms = 5184000000

  access {
    role          = "OWNER"
    user_by_email = google_service_account.service_account-dp-b.email
  }
}
