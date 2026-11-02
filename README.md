# tool

## NL026 / NL031 tmux sessions

Install the `tw`, `t26`, `t31`, `t31-gui`, `t31-doc`, `t31-resin`,
`t26-reset`, and `t31-reset` aliases once:

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

The three PhotonGui commands open independent sessions:

| Command | Directory under `~/Documents/src/NL031/` | Windows |
| --- | --- | --- |
| `t31-gui` | `PhotonGui` | Codex, Nvim, Shell, Build |
| `t31-doc` | `PhotonGui-doc` | Codex, Nvim, Shell |
| `t31-resin` | `PhotonGui-Resin` | Codex, Nvim, Shell, Build |

Build opens two side-by-side shell panes. Use Shell for Git and log commands.
The existing `t31` session continues to use `~/Documents/src/ac_lvgl`.

If the session already exists, the command attaches to it without changing its
windows. Recreate the configured window layout explicitly when needed:

```bash
t26 --reset
t31 --reset
t31-gui --reset
t31-doc --reset
t31-resin --reset
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
