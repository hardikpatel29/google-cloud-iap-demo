output "subnets" {
  //value = google_compute_subnetwork.my_subnets[*].self_link
  value = google_compute_subnetwork.my_subnets[*].ip_cidr_range
}

output "my_ip_address" {
  value = local.my_ip_address
}





