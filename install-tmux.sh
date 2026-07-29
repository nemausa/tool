#!/usr/bin/env bash

set -euo pipefail

die() {
    printf '[install-tmux] ERROR: %s\n' "$*" >&2
    exit 1
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="${script_dir}/tmux-session.sh"
tmux_conf_src="${script_dir}/.tmux.conf"
tmux_conf_dest="${TOOL_TMUX_CONF:-${HOME}/.tmux.conf}"
zshrc_path="${TOOL_TMUX_ZSHRC:-${HOME}/.zshrc}"

[[ -f "$launcher" ]] || die "Launcher not found: $launcher"
[[ "$launcher" != *"'"* ]] || die "Launcher path may not contain a single quote."
[[ -f "$tmux_conf_src" ]] || die "tmux config not found: $tmux_conf_src"

if [[ -L "$tmux_conf_dest" ]]; then
    current_target="$(readlink -- "$tmux_conf_dest")"
    if [[ "$current_target" != "$tmux_conf_src" ]]; then
        ln -sf -- "$tmux_conf_src" "$tmux_conf_dest"
        printf '[install-tmux] Relinked %s -> %s\n' "$tmux_conf_dest" "$tmux_conf_src"
    fi
elif [[ -e "$tmux_conf_dest" ]]; then
    tmux_conf_backup="${tmux_conf_dest}.tool-tmux.bak"
    if [[ ! -e "$tmux_conf_backup" ]]; then
        cp -p -- "$tmux_conf_dest" "$tmux_conf_backup"
    fi
    ln -sf -- "$tmux_conf_src" "$tmux_conf_dest"
    printf '[install-tmux] Backed up existing %s to %s and linked to %s\n' "$tmux_conf_dest" "$tmux_conf_backup" "$tmux_conf_src"
else
    ln -s -- "$tmux_conf_src" "$tmux_conf_dest"
    printf '[install-tmux] Linked %s -> %s\n' "$tmux_conf_dest" "$tmux_conf_src"
fi

if [[ -L "$zshrc_path" ]]; then
    zshrc_path="$(readlink -f -- "$zshrc_path")"
fi

zshrc_dir="$(dirname -- "$zshrc_path")"
mkdir -p -- "$zshrc_dir"

start_marker="# >>> tool tmux sessions >>>"
end_marker="# <<< tool tmux sessions <<<"
backup_path="${zshrc_path}.tool-tmux.bak"
temporary_file="$(mktemp "${zshrc_dir}/.zshrc.tool-tmux.XXXXXX")"

cleanup() {
    rm -f -- "$temporary_file"
}
trap cleanup EXIT

if [[ -e "$zshrc_path" ]]; then
    if [[ ! -e "$backup_path" ]]; then
        cp -p -- "$zshrc_path" "$backup_path"
    fi
    zshrc_mode="$(stat -c '%a' -- "$zshrc_path")"

    awk -v start="$start_marker" -v finish="$end_marker" '
        $0 == start { skipping = 1; next }
        $0 == finish { skipping = 0; next }
        !skipping { lines[++count] = $0 }
        END {
            while (count > 0 && lines[count] == "") {
                count--
            }
            for (i = 1; i <= count; i++) {
                print lines[i]
            }
        }
    ' "$zshrc_path" > "$temporary_file"
else
    zshrc_mode="644"
    : > "$temporary_file"
fi

if [[ -s "$temporary_file" ]]; then
    printf '\n' >> "$temporary_file"
fi

cat >> "$temporary_file" <<EOF
$start_marker
alias tw='$launcher NL031'
alias t26='$launcher NL026'
alias t31='$launcher NL031'
alias t26-reset='$launcher NL026 --reset'
alias t31-reset='$launcher NL031 --reset'
$end_marker
EOF

chmod "$zshrc_mode" "$temporary_file"
mv -- "$temporary_file" "$zshrc_path"
trap - EXIT
chmod u+x -- "$launcher"

printf '[install-tmux] Installed tw, t26, t31, t26-reset, and t31-reset in %s\n' "$zshrc_path"
printf '[install-tmux] Run: source %q\n' "$zshrc_path"
