#!/bin/bash

# Colors definitions
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0)
BOLD=$(tput bold)

# Check if necessary applications are installed
if ! [ -x "$(command -v wget)" ]; then
  printf "\n${RED}wget not found in path. Please install it to continue!${NC}\n"
  exit
fi

if ! [ -x "$(command -v curl)" ]; then
  printf "\n${RED}curl not found in path. Please install it to continue!${NC}\n"
  exit
fi

CURL_CMD="curl -L -w http_code=%{http_code}"
# Update function
install_go() {
  printf "${RED}Updating golang...${NC}\n"
  HTTPS_URL="https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"
  mkdir -p /tmp/golang
  cd /tmp/golang
  CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/golang/golang.tar.gz`
  HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
  ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')

  if [[ ${HTTP_CODE} == 200 ]]; then
    # untar then move to /usr/local/bin
    rm -rf /usr/local/go
    tar -C /usr/local -xzf /tmp/golang/golang.tar.gz
    printf "${GREEN}golang has been updated successfully!${NC}\n"
  else
    printf "${RED}golang has NOT been updated! ERROR: ${ERROR_MESSAGE}${NC}\n"
  fi
}

install_go
