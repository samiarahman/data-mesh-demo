terraform {
  required_providers {
    google = "~> 3.16"
  }
}

provider "google" {
  credentials = file("account.json")
  project     = var.project 
}

