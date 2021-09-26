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

if ! command -v brew &> /dev/null; then
  error "brew could not be found."
fi

info "Installing ${YELLOW}dnsmasq${LIGHTBLUE} via brew."
brew install dnsmasq || error "Failed to install dnsmasq" ; ok

info "Setting up dnsmasq to resolve ${YELLOW}${ZONE}${LIGHTBLUE} zone as 127.0.0.1."
mkdir -pv $(brew --prefix)/etc/
echo "address=/${ZONE}/127.0.0.1" >> $(brew --prefix)/etc/dnsmasq.conf
echo "port=53" >> $(brew --prefix)/etc/dnsmasq.conf
ok

info "Starting dnsmasq daemon (sudo password will be required)."
sudo brew services start dnsmasq || error "Failed to start dnsmasq"; ok

info "Creating resolver."
sudo mkdir -pv /etc/resolver
sudo bash -c "echo \"nameserver 127.0.0.1\" > /etc/resolver/${ZONE:1}"
ok

success
success "That's it! You can run ${YELLOWB}scutil --dns${GREEN} to show all your current resolvers,"
success "and you should see that all requests for a domain ending in ${YELLOWB}${ZONE}${GREEN} will go"
success "to the DNS server at 127.0.0.1"
