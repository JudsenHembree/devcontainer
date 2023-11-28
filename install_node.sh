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
# Update NodeJS
update_nodejs() {
  printf "${RED}Updating NodeJS...${NC}\n"
  HTTPS_URL="https://nodejs.org/dist/v21.1.0/node-v21.1.0-linux-x64.tar.xz"
  mkdir -p /tmp/nodejs
  cd /tmp/nodejs
  CURL_OUTPUT=`${CURL_CMD} ${HTTPS_URL} -o /tmp/nodejs/node-v21.1.0-linux-x64.tar.xz`
  HTTP_CODE=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
  ERROR_MESSAGE=$(echo "${CURL_OUTPUT}" | sed -e 's/http_code.*//')
  if [[ ${HTTP_CODE} == 200 ]]; then
    # untar then move to /usr/local/bin
    tar -xvf /tmp/nodejs/node-v21.1.0-linux-x64.tar.xz;
    mv /tmp/nodejs/node-v21.1.0-linux-x64 /usr/local/bin/nodejs_dir
    ln -s /usr/local/bin/nodejs_dir/bin/node /usr/local/bin/node
    ln -s /usr/local/bin/nodejs_dir/bin/npm /usr/local/bin/npm
    ln -s /usr/local/bin/nodejs_dir/bin/npx /usr/local/bin/npx
    printf "${GREEN}NodeJS has been updated successfully!${NC}\n"
  else
    printf "${RED}NodeJS has NOT been updated! ERROR: ${ERROR_MESSAGE}${NC}\n"
  fi
}
update_nodejs
