terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.18.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = "./keys/cred.json"
  project     = "de-zoomcamp-447504"
  region      = "us-central1"
}


resource "google_storage_bucket" "gcp-bucket" {
  name          = "de-zoomcamp-447504-gcp-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
