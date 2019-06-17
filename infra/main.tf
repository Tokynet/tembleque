#Configure TF things

provider "digitalocean" {}

#Get our ssh_key fingerprint:
data "digitalocean_ssh_key" "dhost" {
  name = "${var.sshkeyid}"
}

#Get image information:
data "digitalocean_image" "centos" {
  slug = "centos-7-x64"
}

#Create our droplet:
resource "digitalocean_droplet" "dhost" {
  image    = "${data.digitalocean_image.centos.id}"
  name     = "tembleque1"
  region   = "${var.digiregion}"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${data.digitalocean_ssh_key.dhost.id}"]
}

#Create a FW for the droplet above:
resource "digitalocean_firewall" "homenet" {
  name = "Access-from-home-IP"

  droplet_ids = [
    "${digitalocean_droplet.dhost.id}",
  ]

  inbound_rule {
    protocol   = "tcp"
    port_range = "22"

    source_addresses = [
      "71.171.90.203/32",
    ]
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"

    source_addresses = [
      "71.171.90.203/32",
    ]
  }

  #There is NO implicit outbound rule, if you don't add this, you will not go too far :)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
