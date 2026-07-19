#!/usr/bin/env bash

set -euo pipefail

die() {
    printf '[install-tmux] ERROR: %s\n' "$*" >&2
    exit 1
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="${script_dir}/tmux-session.sh"
zshrc_path="${TOOL_TMUX_ZSHRC:-${HOME}/.zshrc}"

[[ -f "$launcher" ]] || die "Launcher not found: $launcher"
[[ "$launcher" != *"'"* ]] || die "Launcher path may not contain a single quote."

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
alias t26='$launcher NL026'
alias t31='$launcher NL031'
$end_marker
EOF

chmod "$zshrc_mode" "$temporary_file"
mv -- "$temporary_file" "$zshrc_path"
trap - EXIT
chmod u+x -- "$launcher"

printf '[install-tmux] Installed t26 and t31 in %s\n' "$zshrc_path"
printf '[install-tmux] Run: source %q\n' "$zshrc_path"
