#Configure outputs

output "Droplet name" {
  value = "${digitalocean_droplet.dhost.name}"
}

output "Droplet IP" {
  value = "${digitalocean_droplet.dhost.ipv4_address}"
}

output "Droplet status" {
  value = "${digitalocean_droplet.dhost.status}"
}
