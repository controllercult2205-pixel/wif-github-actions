terraform {
  backend "gcs" {
    bucket = "lz-test-14279-tfstate"
    prefix = "workspace/dev"
  }
}
