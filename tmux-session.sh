#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  tmux-session.sh NL026 [--reset] [--yes]
  tmux-session.sh NL031 [--reset] [--yes]

Options:
  --reset  Recreate an existing session after confirmation.
  --yes    Skip the reset confirmation.
  -h, --help
EOF
}

die() {
    printf '[tmux-session] ERROR: %s\n' "$*" >&2
    exit 1
}

profile=""
reset_session=0
assume_yes=0

while (($# > 0)); do
    case "$1" in
        NL026|NL031)
            [[ -z "$profile" ]] || die "Only one profile may be selected."
            profile="$1"
            ;;
        --reset)
            reset_session=1
            ;;
        --yes)
            assume_yes=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "Unknown argument: $1"
            ;;
    esac
    shift
done

[[ -n "$profile" ]] || {
    usage >&2
    die "Select NL026 or NL031."
}

case "$profile" in
    NL026)
        project_dir="${HOME}/Documents/src/NL026"
        ;;
    NL031)
        project_dir="${HOME}/Documents/src/ac_lvgl"
        ;;
esac

session_name="$profile"
docs_dir="${HOME}/Documents/docs/AnyCubic"
codex_command="${TOOL_TMUX_CODEX_COMMAND:-codex}"
claude_command="${TOOL_TMUX_CLAUDE_COMMAND:-claude}"

tmux_args=(tmux)
if [[ -n "${TOOL_TMUX_SOCKET:-}" ]]; then
    tmux_args+=(-L "$TOOL_TMUX_SOCKET")
fi

tmux_cmd() {
    "${tmux_args[@]}" "$@"
}

session_exists() {
    tmux_cmd has-session -t "$session_name" 2>/dev/null
}

attach_or_switch() {
    if [[ "${TOOL_TMUX_NO_ATTACH:-0}" == "1" ]]; then
        return
    fi

    if [[ -n "${TMUX:-}" && -z "${TOOL_TMUX_SOCKET:-}" ]]; then
        tmux_cmd switch-client -t "$session_name"
    else
        exec "${tmux_args[@]}" attach-session -t "$session_name"
    fi
}

if session_exists && ((reset_session == 0)); then
    attach_or_switch
    exit 0
fi

command -v tmux >/dev/null 2>&1 || die "tmux is not installed."
[[ -d "$project_dir" ]] || die "Project directory does not exist: $project_dir"
[[ -d "$docs_dir" ]] || die "Documentation directory does not exist: $docs_dir"

codex_executable="${codex_command%%[[:space:]]*}"
claude_executable="${claude_command%%[[:space:]]*}"
command -v "$codex_executable" >/dev/null 2>&1 || die "Command not found: $codex_executable"
command -v "$claude_executable" >/dev/null 2>&1 || die "Command not found: $claude_executable"
zsh_path="$(command -v zsh)" || die "zsh is not installed."

persistent_zsh_command() {
    local command_line="$1"
    [[ "$command_line" != *"'"* ]] || die "Launch commands may not contain a single quote."
    printf "exec %s -ic '%s; exec %s'" "$zsh_path" "$command_line" "$zsh_path"
}

if session_exists; then
    current_session=""
    if [[ -n "${TMUX:-}" && -z "${TOOL_TMUX_SOCKET:-}" ]]; then
        current_session="$(tmux display-message -p '#S' 2>/dev/null || true)"
    fi

    if [[ "$current_session" == "$session_name" ]]; then
        die "Detach from $session_name before running '$profile --reset'."
    fi

    if ((assume_yes == 0)); then
        [[ -t 0 ]] || die "Reset requires confirmation; use --yes in a non-interactive shell."
        printf "Reset tmux session '%s' and stop all of its processes? [y/N] " "$session_name"
        read -r answer
        case "$answer" in
            y|Y|yes|YES)
                ;;
            *)
                printf '[tmux-session] Reset cancelled.\n'
                exit 0
                ;;
        esac
    fi

    tmux_cmd kill-session -t "$session_name"
fi

session_created=0
cleanup_partial_session() {
    status=$?
    if ((session_created == 1)); then
        tmux_cmd kill-session -t "$session_name" >/dev/null 2>&1 || true
        session_created=0
    fi
    return "$status"
}
trap cleanup_partial_session EXIT

tmux_cmd new-session -d -s "$session_name" -n Codex -c "$project_dir" "$(persistent_zsh_command "$codex_command")"
session_created=1

first_window_index="$(tmux_cmd display-message -p -t "${session_name}:Codex" '#{window_index}')"
[[ "$first_window_index" == "1" ]] || die "tmux base-index must be 1 (got $first_window_index)."

tmux_cmd new-window -d -t "${session_name}:2" -n Claude -c "$project_dir" "$(persistent_zsh_command "$claude_command")"
tmux_cmd new-window -d -t "${session_name}:3" -n Run -c "$project_dir"
tmux_cmd new-window -d -t "${session_name}:4" -n AnyCubic -c "$docs_dir"
tmux_cmd new-window -d -t "${session_name}:5" -n Shell-1 -c "$project_dir"

tmux_cmd set-window-option -t "$session_name" automatic-rename off >/dev/null
tmux_cmd set-window-option -t "$session_name" allow-rename off >/dev/null

tmux_cmd select-window -t "${session_name}:1"

session_created=0
trap - EXIT

attach_or_switch
