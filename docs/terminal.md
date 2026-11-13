# Bottom terminal: run commands beside your code

Press **Ctrl-/** in normal mode to open a full-width terminal at the bottom of the
current tab. It starts 12 rows high and focuses the shell ready for typing.
The same shortcut hides the terminal directly from terminal input or normal
mode. No plugin is required.

## Brief usage

For example, start `nvim` from your project, open a source file, then press **Ctrl-/**.
Run `pwd` to check the shell's directory, or `python3 main.py` to run a Python
program when Python is installed. Commands run in the shell as in an ordinary
terminal; **Ctrl-c** interrupts a running command.

To hide the terminal, press **Ctrl-/**. Press **Ctrl-/** in your code to bring
back the same shell, output, and working directory. Hiding keeps running commands
alive; it does not exit the shell.

Press **Esc Esc** quickly to leave terminal input and enter normal mode while
keeping the pane open. You can then scroll with normal motions or press **Ctrl-w k**
to move to the code above. Press **i** in the terminal to resume shell input.
The two Esc presses use Neovim's existing `timeoutlen` setting; it is not changed.
A single Esc is forwarded to terminal applications after the mapping timeout.

To end the shell, type `exit` and press Enter. This Neovim version automatically
closes the terminal after a successful shell exit. The next **Ctrl-/** starts a fresh
shell. If exited output stays visible (for example, after `exit 1`, or on an
older Neovim version), use **Ctrl-/** to hide it.
Reopening then removes the finished hidden buffer and starts a new shell.

## Commands and controls

| Mode / context | Keys or command | Effect |
| --- | --- | --- |
| Normal, terminal input | `Ctrl-/` | Toggle the bottom terminal; description: `Toggle bottom terminal`. |
| Normal, terminal input | `Ctrl-_` | Same toggle: compatibility encoding sent by some terminals for Ctrl-/. |
| Terminal input | `Esc Esc` | Enter terminal normal mode without hiding; description: `Enter terminal normal mode`. |
| Command | `:BottomTerminal` | Same toggle, independent of how the terminal encodes Ctrl-/. |
| Terminal input | `Ctrl-\`, then `Ctrl-n` | Native keys: enter terminal normal mode. |
| Terminal normal | `i` | Resume typing into the shell. |
| Normal | `Ctrl-w k` / `Ctrl-w j` | Native keys: move to the window above/below. Leave terminal input first. |
| Terminal normal | `:resize 16` | Resize the current terminal split to 16 rows; reopening resets it to 12. |
| Shell prompt | `exit`, then Enter | End the shell; this Neovim version closes the pane automatically on success. |
| Command | `:help terminal` | Open native terminal help; `:q` closes help. |

The old `?` mapping is removed: normal-mode `?` opens Neovim's backward-search
prompt, plugin help mappings still apply in their own buffers, and typing `?`
in terminal input sends a literal question mark. No insert-mode mapping is added.
The new terminal-input mappings apply to all terminal buffers. Ctrl-/ is reserved
for this bottom-terminal toggle, so terminal applications do not receive that key.

Ctrl-/ may arrive as Ctrl-_ in terminals using traditional key encoding. Both
are mapped; terminals with an extended keyboard protocol can report Ctrl-/
distinctly. `:BottomTerminal` is also available if a terminal intercepts the key.

## Dependencies, configuration, and automatic behavior

The only requirements are Neovim's native terminal support and an executable
shell selected by Neovim's `shell` option. Inspect it with `:set shell?`.
Tools you run, such as Python or a compiler, must be installed separately.

`lua/config/keymaps.lua` defines the Ctrl-/ and Ctrl-_ toggles, terminal-input
Esc Esc mapping, and `:BottomTerminal`. The toggles load `lua/config/terminal.lua`
only when used. The module starts one reusable shell
per Neovim session with native `:terminal`; no startup terminal, plugin setup,
autocommand, or installation step is added.

| Choice | Behavior / reason |
| --- | --- |
| `botright 12new` / `botright 12split` | Create/reopen a full-width bottom split at an initial height of 12 rows; reopening displays the remembered terminal buffer. |
| Remembered terminal buffer | Reuse the process, scrollback, and shell state when toggling. |
| Terminal `bufhidden = "hide"` | Keep the shell alive when its window closes, without changing global `hidden`. |
| `jobwait(..., 0)` | Check whether the remembered shell is still running without waiting. |
| `startinsert` | Focus terminal input when opening or reopening the view. |
| Finished hidden buffer deletion | Replace an exited shell on reopening; its old output is discarded then. |

A new shell inherits Neovim's working directory (`:pwd`) at creation. Reopening
a running shell preserves its own directory, including changes made with `cd`;
it does not follow subsequent Neovim directory changes automatically. Other tabs
can display the same shell; toggling hides only its view in the current tab.
If the terminal is the tab's only window, hiding displays an empty buffer so
Neovim can keep a window open. Manually deleting the terminal buffer means the
next toggle creates a new shell. Shells are not restored across Neovim restarts.

Validation: startup passed. Checks with an attached Neovim UI covered the Ctrl-/
and Ctrl-_ encodings, toggling directly from terminal input, Esc Esc to normal
mode, restored backward search on `?`, bottom placement, and shell input.
The terminal lifecycle checks also cover hiding/reopening with preserved shell
variables, unsaved editor content, successful and failed shell exits, and
reopening after manually closing or deleting the terminal view/buffer.

## Disable or remove

Remove the `toggle_terminal` helper, the Ctrl-/ and Ctrl-_ mapping loop, the
terminal-input Esc Esc mapping, and the `BottomTerminal` command from
`lua/config/keymaps.lua`, then restart Neovim. The unused `lua/config/terminal.lua` can remain on disk
because nothing loads it automatically. No plugins need removing. Update
README.md and docs/features.md alongside the change.
