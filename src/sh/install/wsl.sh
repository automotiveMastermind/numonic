#! /usr/bin/env sh

set -e

user_dir="/mnt/c/Users/${USER}"
appdata_dir="${user_dir}/AppData/Local"
font_dir="${appdata_dir}/Microsoft/Windows/Fonts/NerdFonts"

if [ ! -d "${appdata_dir}" ]; then
	print-warn '' \
		'wsl: local application data directory is not available at the expected location...' \
		'' \
		"EXPECTED: ${appdata_dir}" \
	''
	return 0
fi

# download fonts
print-success "wsl: upgrading fira code font..."
temp_dir=$(mktemp -d)
curl --fail \
	--silent \
	--show-error \
	--location \
	--output "${temp_dir}"/FiraCode.zip \
	https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip

# determine if fira code already exists
if [ -d "${font_dir}" ]; then

	# delete fira code
	rm -rf "${font_dir}" 1>/dev/null 2>&1
fi

# make sure the font dir exists
mkdir -p "${font_dir}" 1>/dev/null

# extract fira code
unzip "${temp_dir}"/FiraCode.zip 'Fira*Windows*.ttf' -d "${font_dir}" 1>/dev/null

# remove temp
rm -rf "${temp_dir}" 1>/dev/null 2>&1

# determine if wsl mount options are configured
if [ ! -f "/etc/wsl.conf" ]; then
	print-success "wsl: configuring metadata mount options"
	sudo tee /etc/wsl.conf 1>/dev/null 2>&1 <<-'EOT'
		[automount]
		enabled = true
		options = "metadata"
	EOT
fi

# determine if ssh remoting is configured
if [ -d "/etc/ssh/sshd_config.d" ] && [ ! -f "/etc/ssh/sshd_config.d/wsl_config" ]; then
	print-success "wsl: configuring ssh remoting..."
	sudo tee /etc/ssh/sshd_config.d/wsl_config 1>/dev/null 2>&1 <<-'EOT'
		Port 2222
		ListenAddress 0.0.0.0
		PasswordAuthentication yes
	EOT
fi

# determine if ssh service can be started without password
if [ -d "/etc/sudoers.d" ] && [ ! -f "/etc/sudoers.d/wsl" ]; then
	sudo tee /etc/sudoers.d/wsl 1>/dev/null 2>&1 <<-'EOT'
		sudo ALL=NOPASSWD: /usr/sbin/service ssh *
	EOT

	sudo chmod 0440 /etc/sudoers.d/wsl
fi
