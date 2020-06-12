terraform {
  required_providers {
    google = "~> 3.16"
  }

  backend "gcs" {
    credentials = "./account.json"
    bucket  = "data-mesh-demo-tf"
    prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file("account.json")
  project     = var.project 
}

