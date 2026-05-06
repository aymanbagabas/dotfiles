#!/bin/sh

# Configure WSL settings (only applies inside WSL).

if [ -z "$WSL_DISTRO_NAME" ]; then
	return 0
fi

# Ensure /etc/wsl.conf has systemd enabled
if [ -f /etc/wsl.conf ] && grep -q "systemd=true" /etc/wsl.conf; then
	echo "systemd already enabled in /etc/wsl.conf."
else
	if ! $DRY_RUN; then
		echo "Enabling systemd in /etc/wsl.conf..."
		if [ -f /etc/wsl.conf ] && grep -q "^\[boot\]" /etc/wsl.conf; then
			# [boot] section exists, add systemd=true after it
			sudo sed -i '/^\[boot\]/a systemd=true' /etc/wsl.conf
		elif [ -f /etc/wsl.conf ]; then
			# File exists but no [boot] section, append
			printf '\n[boot]\nsystemd=true\n' | sudo tee -a /etc/wsl.conf > /dev/null
		else
			# File does not exist, create it
			printf '[boot]\nsystemd=true\n' | sudo tee /etc/wsl.conf > /dev/null
		fi
		echo "Run 'wsl --shutdown' from Windows and restart WSL for systemd to take effect."
	fi
fi
