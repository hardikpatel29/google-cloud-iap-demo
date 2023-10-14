data "http" "my_public_ip" {
  url = "https://httpbin.org/ip"
}

locals {
  
  my_ip_address = jsondecode(data.http.my_public_ip.body)["origin"]


  permission = {
    
    "roles/compute.admin"          = "user:patelsaheb29@gmail.com",
    "roles/iam.serviceAccountUser" = "user:patelsaheb29@gmail.com"
    
  }


  firewall_rules = {
    "ssh" = {
      name        = "allow-ssh"
      description = "Allow SSH traffic"
      direction   = "INGRESS"
      priority    = 1000
      port        = 22
      protocol    = "tcp"
    },
    "http" = {
      name        = "allow-http"
      description = "Allow HTTP traffic"
      direction   = "INGRESS"
      priority    = 1001
      port        = 80
      protocol    = "tcp"
    },
    "https" = {
      name        = "allow-https"
      description = "Allow HTTPS traffic"
      direction   = "INGRESS"
      priority    = 1002
      port        = 443
      protocol    = "tcp"
    },
  }
}