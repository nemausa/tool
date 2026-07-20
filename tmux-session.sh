#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  tmux-session.sh WORKSPACE [--reset] [--yes]

Options:
  --reset  Recreate an existing session after confirmation.
  --yes    Skip the reset confirmation.
  -h, --help

Workspace definitions are loaded from tmux-workspaces/ next to this script.
EOF
}

die() {
    printf '[tmux-session] ERROR: %s\n' "$*" >&2
    exit 1
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${TOOL_TMUX_CONFIG_DIR:-${script_dir}/tmux-workspaces}"

profile=""
reset_session=0
assume_yes=0

while (($# > 0)); do
    case "$1" in
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
        -*)
            usage >&2
            die "Unknown argument: $1"
            ;;
        *)
            [[ -z "$profile" ]] || die "Only one profile may be selected."
            [[ "$1" =~ ^[[:alnum:]][[:alnum:]_.-]*$ ]] || die "Invalid workspace name: $1"
            profile="$1"
            ;;
    esac
    shift
done

[[ -n "$profile" ]] || {
    usage >&2
    die "Select a workspace."
}

session_name="$profile"
config_path="${config_dir}/${profile}.conf"
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
    tmux_cmd has-session -t "=${session_name}" 2>/dev/null
}

attach_or_switch() {
    if [[ "${TOOL_TMUX_NO_ATTACH:-0}" == "1" ]]; then
        return
    fi

    if [[ -n "${TMUX:-}" && -z "${TOOL_TMUX_SOCKET:-}" ]]; then
        tmux_cmd switch-client -t "=${session_name}"
    else
        exec "${tmux_args[@]}" attach-session -t "=${session_name}"
    fi
}

if session_exists && ((reset_session == 0)); then
    attach_or_switch
    exit 0
fi

command -v tmux >/dev/null 2>&1 || die "tmux is not installed."
[[ -f "$config_path" ]] || die "Workspace config not found: $config_path"

zsh_path="$(command -v zsh)" || die "zsh is not installed."

trim() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

window_names=()
window_directories=()
window_commands=()
line_number=0

while IFS= read -r config_line || [[ -n "$config_line" ]]; do
    ((line_number += 1))
    config_line="$(trim "$config_line")"
    [[ -z "$config_line" || "$config_line" == \#* ]] && continue

    IFS='|' read -r window_name directory command <<< "$config_line"
    window_name="$(trim "$window_name")"
    directory="$(trim "${directory:-}")"
    command="$(trim "${command:-}")"

    [[ -n "$window_name" ]] || die "$config_path:$line_number: window name is empty."
    [[ -n "$directory" ]] || die "$config_path:$line_number: working directory is empty."

    case "$directory" in
        '~')
            directory="$HOME"
            ;;
        '~/'*)
            directory="${HOME}/${directory:2}"
            ;;
    esac
    [[ -d "$directory" ]] || die "$config_path:$line_number: directory does not exist: $directory"

    case "$command" in
        '@codex')
            command="$codex_command"
            executable="${command%%[[:space:]]*}"
            command -v "$executable" >/dev/null 2>&1 || die "Command not found: $executable"
            ;;
        '@claude')
            command="$claude_command"
            executable="${command%%[[:space:]]*}"
            command -v "$executable" >/dev/null 2>&1 || die "Command not found: $executable"
            ;;
        @*)
            die "$config_path:$line_number: unknown command placeholder: $command"
            ;;
    esac

    window_names+=("$window_name")
    window_directories+=("$directory")
    window_commands+=("$command")
done < "$config_path"

((${#window_names[@]} > 0)) || die "Workspace config contains no windows: $config_path"

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

    tmux_cmd kill-session -t "=${session_name}"
fi

session_created=0
cleanup_partial_session() {
    status=$?
    if ((session_created == 1)); then
        tmux_cmd kill-session -t "=${session_name}" >/dev/null 2>&1 || true
        session_created=0
    fi
    return "$status"
}
trap cleanup_partial_session EXIT

if [[ -n "${window_commands[0]}" ]]; then
    tmux_cmd new-session -d -s "$session_name" -n "${window_names[0]}" -c "${window_directories[0]}" \
        "$(persistent_zsh_command "${window_commands[0]}")"
else
    tmux_cmd new-session -d -s "$session_name" -n "${window_names[0]}" -c "${window_directories[0]}"
fi
session_created=1

first_window_index="$(tmux_cmd display-message -p -t "=${session_name}:" '#{window_index}')"
[[ "$first_window_index" == "1" ]] || die "tmux base-index must be 1 (got $first_window_index)."

for ((i = 1; i < ${#window_names[@]}; i++)); do
    window_index=$((i + 1))
    if [[ -n "${window_commands[i]}" ]]; then
        tmux_cmd new-window -d -t "=${session_name}:${window_index}" -n "${window_names[i]}" \
            -c "${window_directories[i]}" "$(persistent_zsh_command "${window_commands[i]}")"
    else
        tmux_cmd new-window -d -t "=${session_name}:${window_index}" -n "${window_names[i]}" \
            -c "${window_directories[i]}"
    fi
done

tmux_cmd set-window-option -t "=${session_name}:" automatic-rename off >/dev/null
tmux_cmd set-window-option -t "=${session_name}:" allow-rename off >/dev/null

tmux_cmd select-window -t "=${session_name}:1"

session_created=0
trap - EXIT

attach_or_switch
