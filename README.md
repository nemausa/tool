# tool

## NL026 / NL031 tmux sessions

Install the `tw`, `t26`, `t31`, `t26-reset`, and `t31-reset` aliases once:

```bash
cd ~/Documents/src/tool
./install-tmux.sh
source ~/.zshrc
```

Open the corresponding session:

```bash
t26
t31
```

If the session already exists, the command attaches to it without changing its
windows. Recreate the configured window layout explicitly when needed:

```bash
t26 --reset
t31 --reset
```

Use `--yes` together with `--reset` to skip the confirmation. Run reset outside
the session being replaced.

Window layouts live in `tmux-workspaces/*.conf`. Each non-comment line has this
format:

```text
window name|working directory|command
```

Use `@codex` or `@claude` in the command field to honor
`TOOL_TMUX_CODEX_COMMAND` or `TOOL_TMUX_CLAUDE_COMMAND`. Additional workspace
files can be launched directly with `./tmux-session.sh WORKSPACE` without
changing the script.
