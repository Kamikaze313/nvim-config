# Clear quit-command text after closing a window

After `:q` successfully closes a split or a tab's last window, the bottom
command line clears automatically. This fixes the executed `:q` staying visible.

## Brief usage

Open Neovim, run `:vsplit`, then `:q` and Enter. The second window closes and
the command line becomes blank. For a tab example, run `:tabnew`, then `:q`.

The action also handles `:qu`, `:qui`, `:quit`, and their `!` forms. Native quit
behavior still applies: `:q!` discards unsaved edits when Neovim allows it.
If a quit fails because of unsaved changes, its error stays visible; use `:w`
to save before retrying. Quitting the final window exits Neovim normally.

No shortcut, plugin, dependency, or installation is added. Other commands,
search prompts, command history, and the height of the command line use their
existing behavior.

## Configuration and automatic behavior

The `ClearQuitCommand` autocommand group in `lua/config/autocmds.lua` listens
for `CmdlineLeave` on `:`. It recognizes a submitted simple quit command,
then schedules a check after execution. It clears the displayed text with
`echo ""` only when the original window has closed, no new command line is
active, and no new error was reported. Canceled and failed quits are skipped.
The named group uses `clear = true` to prevent duplicate callbacks on reload.

Validation: startup and attached-UI checks passed for split/tab closure, quit
abbreviations, forced quits, visible unsaved-file errors, ordinary command output,
and closing/reopening the terminal while preserving its running shell.

## Disable

Remove the `ClearQuitCommand` block from `lua/config/autocmds.lua` and restart
Neovim. For the current session only, run `:autocmd! ClearQuitCommand`.
Update README.md and docs/features.md when removing the configuration.
