#! /usr/bin/env sh

set -e

# get the shell
SHELL=$(cat "${HOME}"/.local/numonic/.shell)

# determine if there are not any args
if [ "${1:-}" = "" ]; then

	# run the shell
	exec "${SHELL}" -l
fi

# run the shell with args
exec "${SHELL}" -lc "$@"
