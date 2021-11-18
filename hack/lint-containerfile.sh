#! /usr/bin/env sh

set -e

printf '\n%*.0s\n' 120 ""  | tr " " "%"
printf '%s\n' 'lint-containerfile'
printf '%*.0s\n\n' 120 ""  | tr " " "%"

if ! command -v hadolint 1>/dev/null 2>&1; then
	printf 'hadolint not available' 1>&2
	return 1
fi

# lint all container files
find . -name 'Containerfile*' -type f -print0 \
	| xargs -0 hadolint

printf 'PASSED\n'
