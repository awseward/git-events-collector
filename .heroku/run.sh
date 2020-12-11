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
cp shmig/shmig ./bin/
