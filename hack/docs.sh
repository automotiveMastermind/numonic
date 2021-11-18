#! /usr/bin/env sh

set -e

./hack/docs-generate.sh
./hack/docs-manpages.sh
./hack/docs-site.sh
