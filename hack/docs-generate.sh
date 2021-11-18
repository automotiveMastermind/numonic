#! /usr/bin/env sh

set -ex

version=${1:-$(git describe --tags --abbrev=0 || printf '0.0.1-alpha')}
default_author=$(git config user.name || printf 'Numonic Contributors')
default_date=$(date -u +'%B %e, %Y')

repo_path=$(git rev-parse --show-toplevel)
src_path="${repo_path}"/docs/content/commands
man_path="${repo_path}"/src/local/share/man
pandoc_path="${repo_path}/.pandoc"

if [ -d "${man_path}" ]; then
	rm -rf "${man_path}"
fi

mkdir -p "${man_path}"

if [ -d "${pandoc_path}" ]; then
	rm -rf "${pandoc_path}"
fi

mkdir -p "${pandoc_path}"

find "${src_path}" -name '*.md' -type f | while read -r manpage; do

	name=$(grep -E '^man_name:\s+(.*)$' "${manpage}" || printf '')

	if [ -n "${name:-}" ]; then
		name="${name#*': '}"
	else
		name=$(basename "${manpage}")
		name=${name%%.*}
	fi

	if [ "${name}" = "index" ]; then
		name=$(basename "$(dirname "${manpage}")")
	fi

	man_name=$(printf '%s' "${name}" | tr '[:lower:]' '[:upper:]')

	date=$(git log -1 --format="%ad" --date=format:'%B %e, %Y' -- "${manpage}")
	date=${date:-${default_date}}

	section=$(grep -E '^man_section:\s+(.*)$' "${manpage}" || printf '')

	if [ -n "${section:-}" ]; then
		section="${section#*': '}"
	else
		section=1
	fi

	authors=$(git blame "${manpage}" --porcelain 2>/dev/null | grep  "^author " | cut -d ' ' -f 2- | sort | uniq)
	authors=${authors:-${default_author}}

	intermediate_path="${pandoc_path}/${name}.${section}"

	printf '%s\n' "$(cat <<-EOT
		---
		title: ${name}
		man_title: ${man_name}
		man_section: ${section}
		man_header: Numonic Manual
		man_footer: Numonic ${version}
		revision_date: ${date}
		hyphenate: false
		authors:
	EOT
	)" > "${intermediate_path}"

	authors=$(printf '%s' "${authors}" | tr '\n' '|')
	old_ifs=${IFS}
	IFS='|'
	for author in ${authors}; do
		printf '  - %s\n' "${author}" >> "${intermediate_path}"
	done
	IFS=${old_ifs}

	printf -- '---\n\n' >> "${intermediate_path}"
	cat "${manpage}" >> "${intermediate_path}"

	current_path="${man_path}/man${section}"

	if [ ! -d "${current_path}" ]; then
		mkdir -p "${current_path}"
	fi

	current_path="${current_path}/${name}.${section}"

	if command -v pandoc 1>/dev/null 2>&1; then
		pandoc --standalone \
			--from=markdown-smart --to=man \
			--template=./hack/docs.tpl --output="${current_path}" \
			"${intermediate_path}"
	fi
done
