# Snacks Explorer: browse your project beside the code

**Space e** toggles a file tree on the left. It opens at the current file's
nearest Git root (a directory containing `.git`), or the current working
directory if no Git root is found. It does not change Neovim's working directory.
An open sidebar is closed by the same shortcut, within the current tab.

This restores the sidebar previously supplied by LazyVim, configured directly
through lazy.nvim. Telescope's **Space f f** still searches filenames and Oil's
**-** still opens an editable directory buffer, including for `nvim .`.

## Brief usage

For example, start `nvim src/main.c` inside a Git project and press **Space e**.
The tree shows the project and follows the current file. Use **j/k** to move,
**Enter** or **l** to expand a folder or open a file, and **h** to collapse a
folder or move to its parent. Opening a file focuses the code and leaves the
sidebar visible. **Ctrl-w h** returns to the sidebar; **Ctrl-w l** returns to
the code in a simple two-window layout. **Ctrl-w w** cycles windows.

Press **Space e** again to close the sidebar. When focused in the tree,
**q** or **Esc** also closes it. Press **?** in the tree for the complete
upstream key list, then **?** again to hide help. **q** closes the sidebar and
its help together.

To create `src/example.c`, select the `src` directory and press **a**. Enter
`example.c` in the prompt and press **Enter**. The file is created immediately;
select it and press **Enter** to edit. To create a directory, end its name with
`/`. File-operation prompts accept Enter; cancel a Snacks input prompt with
**Esc** twice (first leaves insert mode, second cancels). Renaming may use
Neovim's native input prompt, where **Esc** cancels.

## Commands and controls

The only custom global mapping is **Space e**, in **normal mode**, with the
description `Toggle project file explorer`. Tree controls below are supplied
by Snacks and apply in its normal-mode list unless otherwise stated.

| Keys | Action |
| --- | --- |
| `j` / `k` | Move down/up the file list. |
| `Enter` / `l` | Expand/collapse a folder; open a file in the code window. |
| `h` | Collapse a directory or move to its parent. |
| `Backspace` | Move the explorer root up one directory. |
| `Ctrl-w h` / `Ctrl-w l` / `Ctrl-w w` | Native Neovim window navigation. |
| `H` / `I` | Toggle hidden / Git-ignored files. |
| `a` | Create a file or directory; directories end with `/`. |
| `r` | Rename the current item after entering the destination. |
| `d` | Ask before deleting the current item or selected items. |
| `c` | Copy an item to a prompted destination, or selected items into the current directory. |
| `m` | Move selected items into the current directory, with confirmation; without a selection, prompt to rename. |
| `Tab` / `Shift-Tab` | Select an item and move forward/back; also works in visual mode. |
| `/` or `i` | Focus the sidebar's search input; type to search the tree. |
| `Esc` in search input | Leave insert mode; `/` in normal mode switches back to the list. |
| `u` | Refresh the tree; it also refreshes automatically when files change. |
| `Z` | Collapse all folders. |
| `?` | Show/hide the complete list of upstream controls. |
| `q` / `Esc` in the list | Close the sidebar. |

File operations act on disk after their prompts; they do not wait for `:w` as
Oil does. Deletion shows a No/Yes picker, initially on **No**; choose **Yes**
and Enter to apply, or Esc to cancel. Upstream uses the system trash when a
supported command is available (this machine has `gio trash`). If none is
available it falls back to permanent deletion. A trash command failure is
reported rather than falling back. Unsaved buffers for deleted files can be
closed by the operation, so save wanted edits before deleting through the tree.

| Command | Effect |
| --- | --- |
| `:lua Snacks.explorer()` | Toggle the sidebar at the current working directory. |
| `:lua Snacks.explorer({ cwd = vim.fs.root(0, ".git") or vim.fn.getcwd() })` | Same root selection as Space e. |
| `:lua Snacks.explorer.reveal()` | Reveal the current file, opening a sidebar if needed. |
| `:help snacks-explorer` | Open the plugin's explorer guide; `:q` closes help. |
| `:checkhealth snacks` | Inspect Snacks and its bundled modules; `:q` closes the report. |

## Dependencies and configuration

The installed release is **folke/snacks.nvim v2.31.0**. It requires Neovim
**0.9.4+**; this machine has 0.12.0-dev. Explorer uses Snacks' bundled **picker**, tree, window/layout,
input, rename, and file-operation helpers. These are modules in one plugin;
no separate dependency plugins are installed.

**fd 8.4+** is required for Explorer's search (installed: 10.3.0 in
`~/.local/bin/`, already included in the shell's `PATH`). **Git** supplies
repository status and is also used by lazy.nvim for installation. Ripgrep is
already installed for Telescope and is used if you invoke the explorer's
optional grep action. A supported system-trash command is optional; see deletion
behavior above. No icon plugin or Nerd Font is required for this configuration.

`fd` and `rg` are external dependencies, separate from downloaded plugins.
Install them on each new device; see [new-device setup](plugin-manager.md#on-a-new-device).

`lua/plugins/explorer.lua` owns the specification, explicitly imported by
`lua/config/lazy.lua`. Its separate checkout is
`~/.local/share/nvim/lazy-selected/snacks.nvim`; lazy.nvim generates the exact
installed commit into `lazy-lock.json`. The previous Snacks checkout is preserved.

| Setting | Value | Why |
| --- | --- | --- |
| `version` | `"*"` | Follow stable releases on manual updates and record the installed commit. |
| `lazy`, `priority` | `false`, `1000` | Set up Snacks early as upstream recommends; open the sidebar only on request. |
| `explorer.enabled` | `true` | Enable the selected file sidebar. |
| `explorer.replace_netrw` | `false` | Keep directory arguments and directory buffers handled by Oil. |
| `picker.enabled` | `true` | Explorer requires the bundled picker engine. |
| `picker.ui_select` | `false` | Keep general Neovim selection dialogs unchanged. Explorer's own confirmation picker still works. |
| `picker.prompt` | `"> "` | Use an ordinary text search prompt. |
| `picker.sources.explorer.layout` | `sidebar`, preview disabled | Show the tree on the left without covering the code with a preview. |
| `picker.sources.explorer.jump.close` | `false` | Keep the tree open when selecting a file. |
| Explorer `icons.files.enabled` | `false` | Show names and tree lines without an icon plugin. |
| Explorer `icons.git.enabled` | `false` | Show Git status letters instead of icon-font glyphs. |
| Explorer `icons.ui` | Text markers for live search and selected/unselected items | Keep search/selection indicators readable. |
| Explorer `icons.diagnostics` | `E`, `W`, `H`, `I` | Render native diagnostic labels as text when present. |
| `input.enabled`, `input.icon` | `false`, empty string | Use the bundled helper only for Explorer's own prompts, with no icon or global input replacement. |
| Key `mode`, `desc` | Normal, `Toggle project file explorer` | Keep the toggle discoverable through which-key. |
| Toggle `cwd` | Nearest `.git` root, otherwise `getcwd()` | Recreate project-root browsing without LazyVim. |

Other options use upstream defaults: the sidebar is about 40 columns wide,
follows the current file, watches for filesystem changes while open, and shows
Git status and existing native diagnostics. Hidden and ignored files start
hidden. It remains visible when focus moves back to code. No sidebar opens
automatically at startup. No other Snacks feature is enabled globally;
Explorer calls its own bundled helpers as needed. It does not replace Telescope.

The broad Snacks health report may mention disabled modules, optional icon or
Treesitter support, and the deliberately disabled general `vim.ui.select`
replacement. Those are not requirements for browsing this sidebar.

Validation: startup passed, and interactive checks covered the project-root
toggle, folder expansion, opening a file beside the tree, fd-backed search,
help and sidebar dismissal, and the existing Oil/Telescope shortcuts.

## Disable or remove

Remove `{ import = "plugins.explorer" }` from `lua/config/lazy.lua` and restart
Neovim. Space e, the sidebar, and this Snacks setup stop loading. Oil and
Telescope keep their existing mappings. The specification can remain on disk
because imports are explicit. Optionally use `:Lazy clean` to remove the unused
Snacks checkout from `lazy-selected`. Update README.md and docs/features.md
alongside the change. Preserve `.backups/` and the previous plugin installations.
