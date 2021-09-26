#!/bin/bash
set -e

ZONE=".devenv.test"

END="\033[0m"
BLACK="\033[0;30m"
BLACKB="\033[1;30m"
WHITE="\033[0;37m"
WHITEB="\033[1;37m"
RED="\033[0;31m"
REDB="\033[1;31m"
GREEN="\033[0;32m"
GREENB="\033[1;32m"
YELLOW="\033[0;33m"
YELLOWB="\033[1;33m"
BLUE="\033[0;34m"
BLUEB="\033[1;34m"
PURPLE="\033[0;35m"
PURPLEB="\033[1;35m"
LIGHTBLUE="\033[0;36m"
LIGHTBLUEB="\033[1;36m"

ERROR="${RED}Error:${END}"
function error
{
  echo -e "$ERROR ${REDB}${1}${END}"
  exit 1
}

INFO="${LIGHTBLUE}[INFO]${END}"
function info
{
  echo -e "${LIGHTBLUE}${1}${END}"
}

function success
{
  echo -e "${GREEN}${1}${END}"
}

function ok
{
  echo -e "${LIGHTBLUE}- ${GREEN}OK${LIGHTBLUE}${END}"
}

if ! command -v lsb_release &> /dev/null; then
  error "lsb_release could not be found (not running on Ubuntu 20.04)."
fi

if [[ $(lsb_release -rs) == "20.04" ]]; then
  success "Ubuntu 20.04 detected."
else
  lsb_release -a
  error "Incompatible OS Version."
fi

info "Installing ${YELLOW}dnsmasq${LIGHTBLUE} (sudo password might be required)."
sudo apt-get -y dnsmasq || error "Failed to install dnsmasq" ; ok

info "Setting up dnsmasq to resolve ${YELLOW}${ZONE}${LIGHTBLUE} zone as 127.0.0.1."
sudo echo "address=/${ZONE}/127.0.0.1" >> "/etc/dnsmasq.d/custom-zone"
sudo echo "port=53" >> "/etc/dnsmasq.d/custom-zone"
ok

info "Starting dnsmasq daemon (sudo password will be required)."
sudo systemctl enable --now dnsmasq || error "Failed to enable and/or start dnsmasq"; ok

info "Creating resolver."
sudo mkdir -pv /etc/systemd/resolved.conf.d
sudo bash -c "echo \"[Resolve]\" > /etc/systemd/resolved.conf.d/dns_servers.conf"
sudo bash -c "echo \"DNS=127.0.0.1\" >> /etc/systemd/resolved.conf.d/dns_servers.conf"
sudo bash -c "echo \"Domains=${ZONE:1}\" >> /etc/systemd/resolved.conf.d/dns_servers.conf"
ok

success
success "That's it! You can run ${YELLOWB}resolvectl status${GREEN} to show all your current resolvers,"
success "and you should see that all requests for a domain ending in ${YELLOWB}${ZONE}${GREEN} will go"
success "to the DNS server at 127.0.0.1"
