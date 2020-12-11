#!/usr/bin/env bash

set -euo pipefail

_sep() { echo -e "\n\n--------------------\n\n"; }

### Setup ./bin/

mkdir -v -p bin
PATH="${PATH}:$(pwd)/bin"; export PATH
echo "PATH=${PATH}"

### Install uplink

_sep

curl -L https://github.com/storj/storj/releases/latest/download/uplink_linux_amd64.zip -o uplink_linux_amd64.zip
unzip -o uplink_linux_amd64.zip
chmod +x uplink
mv uplink bin/
rm -f uplink_linux_amd64.zip

which uplink && uplink version


### Install dhall

_sep

readonly dhall_haskell_ver='1.37.0'
readonly dhall_bin_zip_name="dhall-${dhall_haskell_ver}-x86_64-linux.tar.bz2"

wget "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall_haskell_ver}/${dhall_bin_zip_name}" \
  && tar -xjvf "./${dhall_bin_zip_name}" \
  && rm -rvf "./${dhall_bin_zip_name}"

which dhall && dhall --version

### Install pgloader

_sep

# See Aptfile
which pgloader && pgloader --version

### Install shmig

_sep

git clone git://github.com/mbucc/shmig.git
git -C ./shmig checkout 81006b75e31b0772d68f4e988194c4eb33f0c4eb
cp ./shmig/shmig ./bin/

### Install heroku_database_url_splitter

readonly hdus='heroku_database_url_splitter'
readonly hdus_ver='0.0.1'
readonly hdus_tar="${hdus}-${hdus_ver}.tar.gz"

wget "https://github.com/awseward/${hdus}/releases/download/${hdus_ver}/${hdus_tar}" \
  && tar -zxvf "./${hdus_tar}" \
  && mv "./${hdus}" ./bin/ \
  && rm -rf "${hdus_tar}"
