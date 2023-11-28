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
update_neovim() {
  printf "${RED}Updating Neovim Nightly...${NC}\n"
  HTTPS_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"
  mkdir -p /tmp/nvim
  cd /tmp/nvim
  CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/nvim/nvim-linux64.tar.gz`
  HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
  ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')

  if [[ ${HTTP_CODE} == 200 ]]; then
    # untar then move to /usr/local/bin
    tar -xzf /tmp/nvim/nvim-linux64.tar.gz;
    mv /tmp/nvim/nvim-linux64 /usr/local/bin/nvim_dir
    ln -s /usr/local/bin/nvim_dir/bin/nvim /usr/local/bin/nvim
    printf "${GREEN}Neovim Nightly has been updated successfully!${NC}\n"
  else
    printf "${RED}Neovim Nightly has NOT been updated! ERROR: ${ERROR_MESSAGE}${NC}\n"
  fi
}

update_neovim
