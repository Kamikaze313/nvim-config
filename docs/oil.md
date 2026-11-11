# Oil: edit directories like buffers

Oil opens a directory as an editable list of names. Browse it with normal Vim
motions, or edit the list and save to apply file operations.

## Brief usage

In normal mode, press **-** to open the current file's directory. Use **j/k**
to move and **Enter** to open a file or enter a subdirectory. Inside Oil,
**-** goes up one directory and **Ctrl-c** in normal mode closes the view.

Example: place the cursor on `test.c`, edit just its name to `main.c`, and
return to normal mode. Type **:w** to review the pending rename, then press
**y** to apply it or **n** to cancel that save. Canceling leaves the proposed
buffer edits available to revise; it does not apply them to disk.

`u` undoes edits to the directory listing before saving. To reload the listing
and discard its unsaved changes, use `:edit!`. Once a save is confirmed, the
operations affect real files. Deletion uses Oil's default permanent-delete
behavior, rather than a trash service.

## Commands and controls

| Command or keys | Use |
| --- | --- |
| `-` in a normal file buffer | Open that file's directory; use the working directory for an unnamed buffer. |
| `:Oil` | Open the current file's directory. |
| `:Oil /path/to/directory` | Open a specific directory. |
| `:Oil --float` | Open the directory view in a floating window. |
| `nvim .` from the terminal | Start Neovim browsing the current directory. |
| `j` / `k` in Oil | Move through entries. |
| `Enter` in Oil | Open the selected file or directory. |
| `-` in Oil | Go to the parent directory. |
| `_` in Oil | Open Neovim's current working directory. |
| `g.` in Oil, normal mode | Toggle hidden files such as `.gitignore`. |
| `Ctrl-p` in Oil | Preview the selected file. |
| `g?` in Oil, normal mode | Show all available Oil shortcuts. |
| `:w` in Oil | Review pending operations from modified Oil buffers; `y` applies and `n` cancels. |
| `Ctrl-c` in Oil, normal mode | Close the directory view and return to the previous buffer when available. |

Press `Esc` first if you are typing in insert mode. The `-` shortcut replaces
Neovim's default normal-mode `-` motion (previous line, first nonblank character).
Oil uses its own buffer-local mappings inside the directory view. Browsing
directories does not automatically change Neovim's working directory (`:pwd`).

## Editing files and folders

| Operation | Edit in the directory listing, then use `:w` and review |
| --- | --- |
| Rename | Change an existing entry's name, keeping its hidden identity prefix. |
| Create a file | Add a new line containing its name, for example `notes.txt`. |
| Create a folder | Add a new line ending in `/`, for example `include/`. |
| Delete | Remove the entry's whole line with `dd`. |
| Move | Change its name to a relative destination, such as `src/main.c`, or cut/paste the entry between Oil buffers. |
| Copy | Duplicate the entry's line and give the copy a different name. |

Oil conceals an internal ID prefix on existing entries. Edit their names rather
than replacing their entire lines when renaming; the ID tells Oil this is the
same file. Use `g?` and `:help oil` for additional operations and mappings.

## Installed configuration

`stevearc/oil.nvim` is installed without additional plugin dependencies. Its
specification lives in `lua/plugins/oil.lua`, explicitly imported by
`lua/config/lazy.lua`. The initial version is v2.16.0, with the exact commit
recorded in `lazy-lock.json`.

| Setting | Value | Reason |
| --- | --- | --- |
| `version` | `"*"` | Follow stable releases on manual updates; record exact installed versions in the lockfile. |
| `lazy` | `false` | Follow Oil's recommendation to load at startup for reliable directory handling. |
| `opts.default_file_explorer` | `true` | Let Oil handle directory arguments and `:edit` on a directory. |
| `opts.columns` | `{}` | Show names without extra columns or an icon dependency. |
| `opts.skip_confirm_for_simple_edits` | `false` | Keep the operation review even for a single rename or creation. |
| `keys` | Normal-mode `-` runs `:Oil`, with a descriptive label | Open the parent directory from any file. |

Other options and Oil's buffer-local controls use upstream defaults. Hidden files
start hidden; continuous filesystem watching is disabled. Default file-operation
hooks can notify attached language servers if those are added later; Oil itself
does not install a language server. Opening a new or renamed entry may first ask
to save its pending changes. Unused Oil buffers are normally cleaned up after
two seconds when no Oil view is visible.

Oil has no dedicated health-check module in this release. Use `:checkhealth lazy`
for manager requirements, `:Lazy` to check the plugin, and `:help oil` for usage.

## Disable or remove

Remove `{ import = "plugins.oil" }` from `lua/config/lazy.lua` and restart
Neovim. Oil's shortcut and directory takeover will stop, and Neovim's built-in
directory browser will be available again. Run `:Lazy clean` to remove Oil's
unused checkout. The specification can remain on disk because imports are
explicit. Update the README and feature selection record in the same change.
