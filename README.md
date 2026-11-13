# Neovim, built one choice at a time

This configuration is being rebuilt from scratch. Every feature is presented
before selection, then installed and documented after selection.

## Current state

- Neovim with LuaJIT and lazy.nvim selected only as a plugin manager.
- Telescope provides file and text search, with plenary as its required helper.
- Oil provides directory browsing and file operations, with no plugin dependencies.
- Snacks Explorer provides a left file sidebar on `Space e`, using its bundled picker and installed fd/Git.
- Gitsigns shows Git changes beside lines and provides hunk actions; it requires Git only.
- Which-key shows available shortcuts after a 200 ms pause; no extra plugins or special font are required.
- mini.pairs inserts matching brackets and quotes in insert mode, with no additional dependencies.
- `Space u c` chooses Default or Everforest and remembers the selection; fonts are chosen in Kitty.
- `Ctrl-/` in normal mode or terminal input toggles a reusable bottom terminal; `Esc Esc` leaves terminal input.
- Executed `:q` / `:quit` text clears after a successful window or tab close; failed-quit errors remain visible.
- Space is the shortcut leader; Telescope loads only when invoked.
- Oil loads at startup to handle directory arguments such as `nvim .`.
- Gitsigns loads when opening a file or running `:Gitsigns` and attaches to Git-tracked files.
- Which-key loads just after startup and labels Find, Git hunks, and Appearance.
- mini.pairs sets up at startup so Telescope search prompts are excluded even on first use; command-line and terminal input are excluded.
- Snacks sets up at startup; the sidebar opens on request, leaving directory buffers to Oil.
- RGB colors are enabled; other editing settings use Neovim defaults and automatic formatting is not configured.
- Plugin installation and update checks are manual; see [manager instructions](docs/plugin-manager.md).
- Search dependencies `fd` and `rg` are installed in `~/.local/bin/` on this device; they are separate from the plugins.
- The previous configuration is backed up; see [recovery instructions](docs/backup.md).
- Choose from the [feature menu](docs/features.md). The [previous setup inventory](docs/previous-setup.md)
  records what was configured, including features that were disabled.

Restart Neovim to use the new configuration. An already-running instance still
has its old plugins and settings loaded.

On a new device, copying this configuration does not copy plugin installations.
Start Neovim, run `:Lazy install`, wait for it to finish, and restart Neovim.
Automatic installation is disabled deliberately. Plugins live in
`~/.local/share/nvim/lazy-selected/`; only the manager is bootstrapped automatically.
See [new-device setup and troubleshooting](docs/plugin-manager.md#on-a-new-device)
for dependencies and installation checks.

## Where configuration lives

| File | Purpose |
| --- | --- |
| `init.lua` | Startup entry point; loads editor modules, then the plugin manager. |
| `lua/config/options.lua` | Space leader and true-color rendering. |
| `lua/config/keymaps.lua` | General shortcuts, including the theme menu and bottom terminal. |
| `lua/config/theme.lua` | Default/Everforest menu, command, and saved selection. |
| `lua/config/terminal.lua` | Reusable native shell in a bottom split; loads on first toggle. |
| `lua/config/autocmds.lua` | Clear retained quit-command text after a successful close. |
| `lua/config/lazy.lua` | Manager bootstrap and documented minimal behavior. |
| `lua/plugins/telescope.lua` | Search plugin, dependency, and shortcuts. |
| `lua/plugins/oil.lua` | Directory editor, confirmation behavior, and parent-directory shortcut. |
| `lua/plugins/gitsigns.lua` | Git change markers, loading behavior, and buffer-local hunk shortcuts. |
| `lua/plugins/which-key.lua` | Shortcut hints, popup delay, group labels, and plain-text key labels. |
| `lua/plugins/explorer.lua` | Project file sidebar, Space e toggle, and required bundled helpers. |
| `lua/plugins/everforest.lua` | Everforest colorscheme, loaded only when selected. |
| `lua/plugins/pairs.lua` | Insert-mode bracket/quote pairing, loading behavior, and mode selection. |
| `lazy-lock.json` | Generated version record for lazy.nvim and all selected plugins. |
| `docs/plugin-manager.md` | Manager commands, dependencies, behavior, and disabling instructions. |
| `docs/telescope.md` | Brief search usage guide, controls, configuration, and removal. |
| `docs/oil.md` | Directory navigation, file editing, confirmation, and removal. |
| `docs/gitsigns.md` | Git signs, hunk navigation/actions, blame, dependencies, and removal. |
| `docs/which-key.md` | Shortcut popup controls, examples, automatic behavior, and removal. |
| `docs/explorer.md` | File-tree navigation, file operations, dependencies, and removal. |
| `docs/appearance.md` | Theme switching, persistence, Kitty font chooser, and disabling instructions. |
| `docs/terminal.md` | Bottom terminal controls, shell lifecycle, dependencies, and disabling instructions. |
| `docs/command-line.md` | Quit-command display cleanup, examples, and disabling instructions. |
| `docs/pairs.md` | Bracket/quote controls, examples, limitations, and disabling instructions. |
| `docs/features.md` | Feature pitches, manager comparison, and selection status. |
| `docs/previous-setup.md` | Reference for rebuilding previous features deliberately. |
| `docs/backup.md` | Backup contents, verification, and recovery. |
| `AGENTS.md` | Instructions for maintaining this configuration. |
| `.gitignore` | Excludes local backups, editor recovery files, and logs. |
| `LICENSE` | License retained from the previous repository. |

As feature plugins are selected, individual plugin configurations will live
in `lua/plugins/`, with one feature per file where practical.

## Documentation rule

Each added setting must explain what it does and why it was selected. Each
feature must document its dependencies, configuration file, commands, shortcuts,
automatic behavior, and how to disable it. Keymaps must include a `desc` field.
Every addition must include a brief usage guide with a practical example.
Update this README and the feature menu in the same change as the configuration.

## Shortcuts

Press these sequences in normal mode. `<leader>` means **Space**.

| Keys | Action |
| --- | --- |
| `Space f f` | Find files below the current working directory. |
| `Space f g` | Search text below the current working directory. |
| `Space f b` | Switch between open buffers. |
| `Space f r` | Reopen recent files. |
| `Space f h` | Search Neovim and installed plugin help. |
| `-` | Open the current file's directory in Oil; inside Oil, go up one level. |
| `Space e` | Toggle the left file tree at the current file's Git root, or working directory outside Git. |
| `Space u c` | Choose Default or Everforest and remember it across restarts. |
| `Ctrl-/` | Toggle the bottom terminal; also works directly from terminal input. |
| `]c` / `[c` | Next/previous Git hunk, including staged changes; native motions in diff windows. |
| `Space h p` | Preview the Git hunk under the cursor. |
| `Space h s` | Stage the hunk, or unstage it when only staged changes are under the cursor. |
| `Space h r` | Reset the hunk's unstaged buffer changes; `u` can undo it. |
| `Space h b` | Show blame for the current line. |

The Git shortcuts are local to buffers attached to Gitsigns. `Space h s` and
`Space h r` also work in visual mode on the selected lines.

To discover shortcuts, press **Space** in normal mode and pause briefly. Press
**f** to see the Find group, then **f** again to open Telescope's file picker.
Press **Esc** to dismiss a which-key popup, or use `:WhichKey` to open the helper
directly. It adds no custom action shortcuts. See the [which-key guide](docs/which-key.md).

Example: start `nvim` from a project directory, press `Space f f`, type `main`,
and press Enter to open the selected file. Inside the picker, use Ctrl-n/Ctrl-p
to move and Ctrl-c to close from insert mode. See the [Telescope guide](docs/telescope.md)
for commands and more controls. Neovim's built-in commands such as `:help`,
`:Tutor`, `:checkhealth`, `:write`, and `:quit` remain available.

To manage files, press `-`, move with `j`/`k`, and press Enter to open a file or
directory. Edit a filename to rename it, then `:w` to review the pending file
operations; `y` applies them and `n` cancels that save. Press Ctrl-c in normal
mode to close Oil. See the [Oil usage guide](docs/oil.md) for create, delete,
move, hidden-file, and undo behavior.

To browse a project beside your code, press **Space e**, move with **j/k**, and
press **Enter** or **l** to expand a folder or open a file. Use **h** to collapse
a folder, **Ctrl-w h/l** to move between the sidebar and code, and **Space e**
again to close it. Inside the tree, **q** also closes it and **?** shows controls.
See the [Explorer guide](docs/explorer.md) for file operations and examples.

To review Git changes, open a tracked file, edit a line, then press `Space h p`
to preview the hunk. Move the cursor to close the popup. Use `Space h s` to
stage it; on that staged hunk, use the same shortcut again to unstage it.
See the [Gitsigns usage guide](docs/gitsigns.md) for signs, commands, and examples.

To change colors, press **Space u c** (or run `:Theme`), enter **1** for Default
or **2** for Everforest, and press **Enter**. **Esc** cancels. `:Theme default`
and `:Theme everforest` apply and remember a choice directly. The first startup
uses Default. For fonts, run `kitten choose-fonts` in a normal Kitty shell;
the font belongs to the terminal and is independent of the Neovim theme.
See the [appearance guide](docs/appearance.md).

To run a command beside your code, press **Ctrl-/** in normal mode. The terminal
opens at the bottom, ready for typing; try `pwd`. Press **Ctrl-/** again to hide
it directly from terminal input, then use the same shortcut to reopen the shell.
Press **Esc Esc** quickly to enter normal mode while keeping the terminal visible;
press **i** to resume shell input. `:BottomTerminal` provides the same toggle.
See the [terminal guide](docs/terminal.md) for window navigation, shell exit,
and terminal key encoding. Normal-mode `?` uses Neovim's backward search again.

To close a split or tab, run **:q** and press Enter. After a successful close,
the bottom command line clears automatically. An unsaved-file error remains
visible if the close fails. See the [command-line guide](docs/command-line.md).

To try automatic pairs, press **i** in an empty editing buffer and type
`print("hello")`. Opening characters insert their match; typing the closing
character skips over the generated one. **Backspace** inside an empty pair
deletes both, and **Esc** leaves insert mode. See the [pairing guide](docs/pairs.md)
for Enter behavior and literal input.

## Startup check

Run from this directory:

```sh
nvim --headless -i NONE -u ./init.lua '+lua assert(vim.v.errmsg == "", vim.v.errmsg)' +qa
```

`--headless` checks startup without a UI; `-i NONE` avoids reading or writing
the ShaDa history file; `-u` selects this configuration; the assertion catches
startup errors; `+qa` exits.
