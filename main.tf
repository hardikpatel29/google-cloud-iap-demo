terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
  backend "gcs" {
    credentials = "gcloud-terraform.json"
    bucket  = "myterraformstate"
    prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file("gcloud-terraform.json")

  project = "inspired-truth-397407"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_project_iam_member" "project" {
  project  = "inspired-truth-397407"
  for_each = local.permission
  role     = each.key
  member   = each.value
}


resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
 
}


resource "google_compute_subnetwork" "my_subnets" {
  count           = var.subnet_count
  name            = var.subnet_names[count.index]
  network         = google_compute_network.vpc_network.name
  region          = "us-central1" 
  ip_cidr_range   = cidrsubnet(var.vpc_cidr, 8, count.index)
}
  

resource "google_compute_firewall" "firewall" {
  for_each = local.firewall_rules

  name    = each.value.name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = each.value.protocol
    ports    = [each.value.port]
  }

  source_ranges = [local.my_ip_address]

  description = each.value.description
  direction   = each.value.direction
  priority    = each.value.priority
}

resource "google_compute_firewall" "iap-ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] 
}



/* resource "google_compute_subnetwork" "subnet" {
  for_each = local.subnets_config

  name          = each.key
  region        = "us-central1" 
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = cidrsubnet("10.0.0.0/16", 8, each.value.prefix_bits)

  //ip_cidr_range = cidrsubnet(google_compute_network.vpc_network.ip_cidr_range, 8, each.value.prefix_bits)

  description = each.value.description
} */
