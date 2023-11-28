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
# isntall the latest clangd
install_clangd() {
  printf "${RED}Installing Clangd...${NC}\n"
  HTTPS_URL="https://github.com/clangd/clangd/releases/download/17.0.3/clangd-linux-17.0.3.zip"
  mkdir -p /tmp/clangd
  cd /tmp/clangd
  CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/clangd/clangd-linux.zip` 
  HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
  ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')
  if [[ ${HTTP_CODE} == 200 ]]; then
    # untar then move to /usr/local/bin
    unzip /tmp/clangd/clangd-linux.zip
    mv /tmp/clangd/clangd_1* /usr/local/bin/clangd_dir
    ln -s /usr/local/bin/clangd_dir/bin/clangd /usr/local/bin/clangd
    printf "${GREEN}Clangd has been updated successfully!${NC}\n"
  else
    printf "${RED}Clangd has NOT been updated! ERROR: ${ERROR_MESSAGE}${NC}\n"
  fi

}

install_clangd
