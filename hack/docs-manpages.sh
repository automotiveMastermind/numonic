#! /usr/bin/env sh

set -e

pandoc_path=".pandoc"
man_path="src/local/share/man"

if ! command -v pandoc 1>/dev/null 2>&1; then
	printf 'docs-manpages: pandoc not found'
	exit 1
fi

if [ ! -d "${pandoc_path}" ]; then
	printf 'docs-manpages: mgenerated docs are missing'
	exit 1
fi

if [ -d "${man_path}" ]; then
	rm -rf "${man_path}"
fi

find "${pandoc_path}" -type f | while read -r manpage; do
	name=$(basename "${manpage}")
	section="${name##*.}"
	current_path="${man_path}/man${section}"

	if [ ! -d "${current_path}" ]; then
		mkdir -p "${current_path}"
	fi

	current_path="${current_path}/${name}"

	printf 'docs-manpages: generating docs for %s\n' "${name}"

	pandoc --standalone \
		--from=markdown-smart --to=man \
		--template=./hack/docs.tpl --output="${current_path}" \
		"${manpage}"
done
