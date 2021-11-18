#! /usr/bin/env sh

set -e

USERNAME=${1:-build}

if command -v apt 1>/dev/null 2>&1; then
	export DEBIAN_FRONTEND=noninteractive

	printf "APT::Get::Assume-Yes \"true\";\n" > /etc/apt/apt.conf.d/99assumeyes
	printf "APT::Acquire::Retries \"10\";\n" > /etc/apt/apt.conf.d/99retries
	printf "APT::Get::Install-Recommends \"false\";\n" > /etc/apt/apt.conf.d/99norecommends
	printf "APT::Get::Install-Suggest \"false\";\n" > /etc/apt/apt.conf.d/99nosuggests
	printf 'DEBIAN_FRONTEND="%s"\n' "$DEBIAN_FRONTEND" | tee -a /etc/environment

	# dont ask for confirmation when overwriting configs
	cat <<- EOF >> /etc/apt/apt.conf.d/99dpkgoptions
		Dpkg::Options {
		"--force-confdef";
		"--force-confold";
		}
	EOF

	# don't prompt to auto-remove
	cat <<- EOF >> /etc/apt/apt.conf.d/99aptautoremove
		APT::Get::AutomaticRemove "false";
		APT::Get::HideAutoRemove "true";
	EOF

	apt update --yes
	apt install --no-install-recommends -y \
		curl \
		findutils \
		libvshadow-utils \
		man-db \
		python3 \
		sudo \
		unzip
fi

yum=$(command -v dnf || command -v yum || printf '')

if [ -n "${yum}" ]; then
	"${yum}" update -y
	"${yum}" install -y \
		curl \
		sudo \
		shadow-utils \
		findutils \
		man-db \
		python3 \
		unzip \
		util-linux-user
fi

if [ ! -f "/etc/subuid" ]; then
	touch /etc/subuid
fi

if [ ! -f "/etc/subgid" ]; then
	touch /etc/subgid
fi

# add the user
useradd \
	--user-group \
	--create-home \
	--no-log-init \
	--groups tty \
	--shell /bin/sh \
	"${USERNAME}"

# own the home for the user
chown -R "${USERNAME}":"${USERNAME}" /home/"${USERNAME}"
chmod u=rwx,g=rx,o= /home/"${USERNAME}"

# add root and user to sudoers without password
printf 'root ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/99-root
printf '%s ALL=(ALL) NOPASSWD:ALL\n' "${USERNAME}" > /etc/sudoers.d/99-user
