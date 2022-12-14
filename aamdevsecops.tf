# Create the maamdevsecops network
resource "google_compute_network" "aamdevsecops" {
  name = "aamdevsecops"
  # Create auto-mode subnets 
  auto_create_subnetworks = "true"
}
# Add a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource "google_compute_firewall" "aamdevsecops-allow-http-ssh-rdp-icmp" {
  name = "mynetwork-allow-http-ssh-rdp-icmp"
  # allow rule for ssh, HTTP, RDP and ICMP
  network = google_compute_network.aamdevsecops.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}
# Create the aamdevsecops-us-vm instance
module "mynet-us-vm" {
  source           = "./instance"
  instance_name    = "aamdevsecops-us-vm"
  instance_zone    = "us-central1-a"
  instance_network = google_compute_network.aamdevsecops.self_link
}
# Create the aamdevsecops-eu-vm" instance
module "mynet-eu-vm" {
  source           = "./instance"
  instance_name    = "aamdevsecops-eu-vm"
  instance_zone    = "europe-west1-c"
  instance_network = google_compute_network.aamdevsecops.self_link
}