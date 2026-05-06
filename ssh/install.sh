#!/bin/sh

mkdir -p ~/.ssh
chmod 700 ~/.ssh
link_file config ~/.ssh/config

# Configure SSH agent forwarding from Windows OpenSSH agent via socat + npiperelay.
# Only applies when running inside WSL.

if [ -n "$WSL_DISTRO_NAME" ]; then
	if ! command_exist socat; then
		if ! $DRY_RUN; then
			echo "Installing socat..."
			sudo apt-get update -qq
			sudo apt-get install -y socat
		fi
	fi

	# Discover npiperelay.exe path from Windows
	NPIPERELAY_PATH=""

	# Check PATH first
	NPIPERELAY_PATH="$(command -v npiperelay.exe 2>/dev/null || true)"

	# Search common Windows locations
	if [ -z "$NPIPERELAY_PATH" ]; then
		WIN_USERPROFILE="$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')"
		if [ -n "$WIN_USERPROFILE" ]; then
			WIN_HOME="$(wslpath "$WIN_USERPROFILE")"
			# winget portable install location
			for f in "$WIN_HOME/AppData/Local/Microsoft/WinGet/Packages"/albertony.npiperelay_*/npiperelay.exe; do
				if [ -x "$f" ]; then
					NPIPERELAY_PATH="$f"
					break
				fi
			done
			# go install location (legacy)
			if [ -z "$NPIPERELAY_PATH" ] && [ -x "$WIN_HOME/go/bin/npiperelay.exe" ]; then
				NPIPERELAY_PATH="$WIN_HOME/go/bin/npiperelay.exe"
			fi
		fi
	fi

	if [ -z "$NPIPERELAY_PATH" ]; then
		echo "npiperelay.exe not found. Install it on Windows first." >&2
		return 1
	fi

	if ! $DRY_RUN; then
		# Create SSH agent relay script
		mkdir -p ~/.local/bin

		cat >~/.local/bin/wsl-ssh-agent-relay <<EOF
#!/bin/sh
# Bridge Windows OpenSSH agent to WSL via socat + npiperelay.
# Source this script from your shell profile.

export SSH_AUTH_SOCK="\$HOME/.ssh/agent.sock"

if ! ss -a 2>/dev/null | grep -q "\$SSH_AUTH_SOCK"; then
	rm -f "\$SSH_AUTH_SOCK"
	mkdir -p "\$(dirname "\$SSH_AUTH_SOCK")"
	(setsid socat UNIX-LISTEN:"\$SSH_AUTH_SOCK",fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
EOF
		chmod +x ~/.local/bin/wsl-ssh-agent-relay
		echo "Installed ~/.local/bin/wsl-ssh-agent-relay"
	fi

	# Add sourcing to .zshrc.local for WSL SSH agent support
	ZSHRC_LOCAL="$HOME/.zshrc.local"
	if ! $DRY_RUN; then
		insert_line "wsl-ssh-agent-relay" '. "$HOME/.local/bin/wsl-ssh-agent-relay"' "$ZSHRC_LOCAL"
	fi
fi
