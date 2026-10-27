terraform {
  required_version = ">= 1.5"
  backend "gcs" {
    bucket = "lz-test-14279-tfstate"
    prefix = "workspace/dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

variable "project_id" { type = string }
variable "region"     { type = string }

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "demo" {
  name                        = "${var.project_id}-demo-bucket"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true
  labels = {
    owner = "platform"
  }
}
