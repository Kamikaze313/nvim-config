# Telescope: find files and project text

Telescope searches filenames, text, open buffers, recent files, and help in a
popup with a preview. It is the first selected general-purpose feature.

## Brief usage

Start Neovim inside your project directory. In normal mode, press **Space f f**,
type part of a filename (for example, `main`), then press **Enter** to open it.
To find where a function is used, press **Space f g**, type its name (for example,
`malloc`), and open a matching line.

Keys in a sequence are pressed one after another. Space is our `<leader>` key,
defined in `lua/config/options.lua` before the plugin manager loads.

| Normal-mode shortcut | Equivalent command | Use |
| --- | --- | --- |
| `Space f f` | `:Telescope find_files` | Find files under the current working directory. |
| `Space f g` | `:Telescope live_grep` | Search file contents under the current working directory. |
| `Space f b` | `:Telescope buffers` | Choose an open buffer. |
| `Space f r` | `:Telescope oldfiles` | Reopen a file from your recent-file history. |
| `Space f h` | `:Telescope help_tags` | Search help topics. |

File and text search use Neovim's current working directory, not automatic
project-root detection. Check it with `:pwd`, or change it with
`:cd /path/to/project`. File search uses fuzzy matching; live text search uses
ripgrep's regular-expression syntax. Hidden files and ignored paths are normally
excluded by the underlying search tools. Recent files may include other projects
and depend on the history available to Neovim; the current file is omitted.

## Inside a search window

The prompt starts in insert mode, ready for typing.

| Keys | Action |
| --- | --- |
| Type text | Filter filenames/lists or update live text search. |
| `Ctrl-n` / `Ctrl-p` or arrow keys | Move to the next/previous result. |
| `Enter` | Open the selected result. |
| `Ctrl-v` / `Ctrl-x` | Open a file result in a vertical/horizontal split. |
| `Ctrl-d` / `Ctrl-u` | Scroll the preview down/up. |
| `Ctrl-c` in insert mode | Close the picker. |
| `Esc` | Leave insert mode; press Esc again in normal mode to close. |
| `?` in normal mode | Show the picker's available controls. |

More help after opening a picker: `:help telescope`. To troubleshoot before
first use, run `:Lazy load telescope.nvim`, then `:checkhealth telescope`.
The explicit load makes the plugin's health check available even when its
on-demand loading has not been triggered by a shortcut yet.

## What is installed and configured

- `nvim-telescope/telescope.nvim`, initially v0.2.2 from the existing local
  checkout. `version = "*"` follows stable releases on manual updates;
  `lazy-lock.json` records the exact installed commit.
- `nvim-lua/plenary.nvim`, the required Lua helper library for Telescope's jobs
  and utilities. It has no separate user workflow or custom settings here.
- `rg` (ripgrep) supplies project text search, and `fd` is available for file
  finding. On this device, ripgrep 14.1.1 and fd 10.3.0 are installed in
  `~/.local/bin/`, which the existing shell configuration includes in `PATH`.
  These executables are separate dependencies and must be installed again on
  another device; copying the Neovim configuration does not transfer them.

`lua/plugins/telescope.lua` contains the specification. Its `cmd = "Telescope"`
and five `keys` entries make the feature load on first use. `dependencies`
loads plenary before Telescope. `opts = {}` calls Telescope's setup with its
default layout, previews, matching, and controls. Each key has a `desc` so its
purpose can be shown by Neovim or a future shortcut helper.

`lua/config/lazy.lua` explicitly imports this specification. Nothing scans or
indexes your project at startup; search jobs begin when a picker is used.
Telescope and plenary stay loaded for the rest of that Neovim session.
Telescope's default query-history handler uses
`~/.local/share/nvim/telescope_history`, separately from Neovim's recent-file history.

There are no additional search extensions, icon plugins, or compiled sorters.
The manager and both plugin copies live under `~/.local/share/nvim/lazy-selected/`,
separate from the preserved previous setup.

## Disable or remove

Remove `{ import = "plugins.telescope" }` from the `spec` list in
`lua/config/lazy.lua` and restart Neovim. This removes the picker commands and
shortcuts from the active setup. Use `:Lazy clean` to delete the unused copies
of Telescope and plenary, provided no other selected plugin needs plenary.
The specification file can stay on disk because imports are explicit.

The Space leader can remain for future shortcuts. To return to Neovim's default
leader, remove `vim.g.mapleader = " "` from `lua/config/options.lua` and restart.
Update the README and selection record alongside either change.
