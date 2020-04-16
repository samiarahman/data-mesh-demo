resource "google_project_service" "service" {
  service = "iam.googleapis.com" 

  project = var.project 
  disable_on_destroy = false
}

resource "google_service_account" "service_account-dp-1" {
  account_id   = "dp-1-sa"
  display_name = "Service Account for data product 1"
}

resource "google_service_account" "service_account-dp-2" {
  account_id   = "dp-2-sa"
  display_name = "Service Account for data product 2"
}

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
}

resource "google_storage_bucket" "dp-1-sb" {
  name          = "dp-1-loading-zone"
  location      = "US"
  force_destroy = true
}


data "google_iam_policy" "dp-1-admin" {
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

resource "google_project_iam_member" "dp-1-sa-bq-job-user" {
  project = var.project 
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-1.email}"
}
resource "google_project_iam_member" "dp-2-sa-bq-job-user" {
  project = var.project 
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account-dp-2.email}"
}

resource "google_storage_bucket" "dp-1-dataflow-temp" {
  name          = "dp-1-df-temp"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "df-1-dataflow-temp-admin" {
  bucket = google_storage_bucket.dp-1-dataflow-temp.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:64709029339-compute@developer.gserviceaccount.com"
}

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
