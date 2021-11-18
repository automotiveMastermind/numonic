#! /usr/bin/env sh

set -e

__numonic_build()
{
	platforms=
	images=
	shells=
	runtime=

	while :; do
			case $1 in
				-d|--debug)
					debug=1
					;;
				-dr|--dry-run)
					dry_run=1
					;;
				-i|--image)
					images="${images} ${2}"
					shift
					;;
				--image=*)
					images="${images} ${1#*=}"
					;;
				-o|--org)
					GITHUB_ORG="${2}"
					;;
				--org=*)
					GITHUB_ORG="${1#*=}"
					;;
				-p|--platform)
					platforms="${platforms},${2}"
					shift
					;;
				--platform=*)
					platforms="${platforms},${1#*=}"
					;;
				-r|--ref)
					GITHUB_REF="${2}"
					shift
					;;
				-cr|--runtime)
					runtime="${2}"
					shift
					;;
				--runtime=*)
					runtime="${1#*=}"
					;;
				--ref=*)
					GITHUB_REF="${1#*=}"
					;;
				-sha|--sha)
					GITHUB_SHA="${2}"
					shift
					;;
				--sha=*)
					GITHUB_SHA="${1#*=}"
					;;
				-s|--shell)
					shells="${shells} ${2}"
					shift
					;;
				--shell=*)
					shells="${shells} ${1#*=}"
					;;
				?*)
					printf "\nbuild: unknown argument: %s\n" "${1}"
					exit 1
					;;
				*)
					break
					;;
			esac
			shift
		done

	if [ -z "${platforms:-}" ]; then
		platforms="linux/amd64,linux/arm64"
	fi

	if [ -z "${images:-}" ]; then
		images="ubuntu:20.04 ubuntu:21.10 debian:10 debian:11 fedora:34 fedora:35 amazonlinux:2 centos:8"
	fi

	if [ -z "${shells:-}" ]; then
		shells="bash zsh"
	fi

	if [ -z "${runtime:-}" ]; then
		if command -v nerdctl 1>/dev/null 2>&1; then
			runtime="nerdctl"
		elif command -v podman 1>/dev/null 2>&1; then
			runtime="podman"
		elif command -v docker 1>/dev/null 2>&1; then
			runtime="docker"
		else
			printf "\nbuild: no supported contianer runtime found\n"
			return 1
		fi
	fi

	platforms="${platforms#,}"

	GITHUB_SHA=${GITHUB_SHA:-$(git rev-parse HEAD)}
	GITHUB_REF=${GITHUB_REF:=$(git rev-parse --abbrev-ref HEAD)}
	GITHUB_ORG=${GITHUB_ORG:-"automotivemastermind"}

	# set up the args to the build command
	set -- \
		--platform="${platforms}" \
		--label=org.opencontainers.image.name=numonic \
		--label=org.opencontainers.image.revision="${GITHUB_SHA}" \
		--label=org.opencontainers.image.version="${GITHUB_REF}" \
		--label=org.opencontainers.image.vendor="automotiveMastermind" \
		--label=org.opencontainers.image.licenses="MIT" \
		--label=org.opencontainers.image.source="https://github.com/${GITHUB_ORG}/numonic"

	(
		if [ -n "${debug:-}" ]; then
			set -x
		fi

		# iterate over each image
		for image in ${images}; do

			# get the name
			from_repo=${image%%\:*}
			from_tag=${image##*\:}

			# determine if a version was specified
			if [ -n "${from_tag}" ] && [ "${from_repo}" != "${from_tag}" ]; then
				name="${from_repo}-${from_tag}"
			else
				name="${from_repo}"
				from_tag="latest"
			fi

			# iterate over each shell
			for shell in ${shells}; do

				# setup the manifest
				tag="numonic:${name}-${shell}"

				printf 'BUILD FOR %s\n' "${tag}"
				printf '%s build\n' "${runtime}"
				printf '\t%s\n' "$@"
				printf '\t%s\n' --build-arg=FROM_REPO="${from_repo}"
				printf '\t%s\n' --build-arg=FROM_TAG="${from_tag}"
				printf '\t%s\n' --build-arg=NUMONIC_SHELL="${shell}"
				printf '\t%s\n\n' --tag="${tag}"

				if [ -n "${dry_run:-}" ]; then
					continue
				fi

				# add the shell to the build command
				"${runtime}" build "$@" \
					--build-arg=IMAGE="${image}" \
					--build-arg=NUMONIC_SHELL="${shell}" \
					--tag="${tag}" \
					"${PWD}"

				"${runtime}" run \
					--volume="${PWD}:/testing" \
					--workdir=/testing "${tag}" \
					./hack/test.sh
			done
		done
	)
}

__numonic_build "$@"
