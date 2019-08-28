#! /usr/bin/env bash

set -e

# remember current directory
NIX_CONCOURSE_PKG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# load custom commit of vgo2nix, build it
TMP_DIR=`mktemp -d`
TMP_VG2N_DIR=${TMP_DIR}/vgo2nix
git clone git@github.com:adisbladis/vgo2nix.git --depth 1 $TMP_VG2N_DIR
cd $TMP_VG2N_DIR
git checkout 56ac56bb0d969aa1c3830aba98e4d912366c2261
nix-build

TMP_CONCOURSE_DIR=${TMP_DIR}/concourse
git clone --branch  v5.4.1 git@github.com:concourse/concourse.git --depth 1 $TMP_CONCOURSE_DIR
cd $TMP_CONCOURSE_DIR

# hop back and build our new deps
cd $TMP_CONCOURSE_DIR
# output path of binary may change with vgo2nix updates
${TMP_VG2N_DIR}/result-bin/bin/vgo2nix -keep-going

# copy results and clean up
cp deps.nix ${NIX_CONCOURSE_PKG_DIR}/deps.nix
rm -rf $TMP_DIR
