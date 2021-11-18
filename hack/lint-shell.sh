#! /usr/bin/env sh

set -e

printf '\n%*.0s\n' 120 ""  | tr " " "%"
printf '%s\n' 'lint-shell'
printf '%*.0s\n' 120 ""  | tr " " "%"

if ! command -v shellcheck 1>/dev/null 2>&1; then
	printf 'shellcheck not available' 1>&2
	return 1
fi

# find all executables shell scripts not in hidden folders and lint them
find . -not -path './.*/*' -type f -perm +ugo+x -print0 \
	| xargs -0 shellcheck -e SC1090,SC1091,SC1071

printf 'PASSED\n'
