#! /usr/bin/env sh

__numonic_lint() {
	final=0

	./hack/lint-shell.sh || final=1
	./hack/lint-containerfile.sh || final=1

	return ${final}
}

__numonic_lint
