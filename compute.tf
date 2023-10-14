resource "google_compute_instance" "MyInstance" {
  //count = var.subnet_count  
  //name         = "demo-${count.index}"
  name         = "demo"
  machine_type = "n1-standard-1"  
  zone         = "us-central1-c"  
  network_interface {
    network = google_compute_network.vpc_network.name
    //subnetwork = google_compute_subnetwork.my_subnets[count.index].name
    subnetwork = element(google_compute_subnetwork.my_subnets[*].name, 0)
    /* access_config {
      nat_ip = element(google_compute_address.public_ip[*].address, 0)
      //nat_ip = google_compute_address.public_ip[count.index].address
    } */
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    EOF

  tags = ["http-server"]

  

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

 
  /* disk {
    source = google_compute_disk.example_disk.name
  } */
}



resource "google_iap_tunnel_instance_iam_member" "instance" {
  //provider = "google-beta"
  
  instance = google_compute_instance.MyInstance.name
  zone     = google_compute_instance.MyInstance.zone
  role     = "roles/iap.tunnelResourceAccessor"
  member   = "user:patelsaheb29@gmail.com"
  depends_on = [google_compute_instance.MyInstance]
}

/* resource "google_compute_address" "public_ip" {
  //count  = var.subnet_count  
  //name   = "my-instance-public-ip-${count.index}"
  name   = "my-instance-public-ip"
  
} */