#! /usr/bin/env sh

set +e

SHELL=${1:-$(cat "${HOME}"/.local/numonic/.shell)}
SHELL=${SHELL##*/}

final=0

__numonic_print_test() {
	printf '%*.0s\n' 120 ""  | tr " " "%"
	printf '%*.0s\n' 120 ""  | tr " " "%"
	printf 'TEST: %s\n' "$*" | tr '[:lower:]' '[:upper:]'
	printf '%*.0s\n' 120 ""  | tr " " "%"
	printf '%*.0s\n' 120 ""  | tr " " "%"
	printf '\n'
}

alias print-test='__numonic_print_test'

if [ -z "${CI:-}" ]; then
	test_home=$(mktemp -d)

	export NUMONIC_LOCAL="${test_home}"/local
	export NUMONIC_HOME="${PWD}"/src

	print-success '' \
		'test: setting up temporary environment...' \
		"NUMONIC_LOCAL : ${NUMONIC_LOCAL}" \
		"NUMONIC_HOME  : ${NUMONIC_HOME}" \
	''
fi

(
	for test in "${PWD}"/test/*.test.sh; do
		shell=${test%/*}
		shell=${shell##*/}

		name=${test##*/}
		name=${name%.test.sh*}
		name="${shell}/${name}"

		print-test "${name}"

		temp=$(mktemp -d)

		(
			cd "${temp}" || exit 1
			TERM=dumb "${SHELL}" -lc "${test}" 1>stdout 2>stderr
		)

		exit_code=$?

		if [ ${exit_code} -ne 0 ]; then
			print-fail "TEST: ${name} FAILED: ${exit_code}"
			printf '\n'
			print-warn "$(cat "${temp}"/stderr)"
			final=1
		else
			print-success "TEST: ${name} PASSED"
		fi

		rm -rf "${temp}"
	done

	exit ${final}
)
