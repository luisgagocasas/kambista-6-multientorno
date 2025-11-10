output "instance_ip" {
  description = "Dirección IPv4 pública de la instancia"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
