#!/bin/bash -ex

export DEBIAN_FRONTEND=noninteractive

# Configure apt proxy if needed.
packer_apt_proxy_config="/etc/apt/apt.conf.d/packer-proxy.conf"
if  [ ! -z  "${http_proxy}" ]; then
  echo "Acquire::http::Proxy \"${http_proxy}\";" >> ${packer_apt_proxy_config}
fi
if  [ ! -z  "${https_proxy}" ]; then
  echo "Acquire::https::Proxy \"${https_proxy}\";" >> ${packer_apt_proxy_config}
fi

ARCH=$(dpkg --print-architecture)

# Configure proxmox repository
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 

# verify
# sourced from https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm
sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 

cat /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 

apt update