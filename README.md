# tool

## NL026 / NL031 tmux sessions

Install the `t26` and `t31` aliases once:

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
windows. Recreate the fixed five-window layout explicitly when needed:

```bash
t26 --reset
t31 --reset
```

Use `--yes` together with `--reset` to skip the confirmation. Run reset outside
the session being replaced.
