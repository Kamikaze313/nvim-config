# Gitsigns: see and review Git changes

Gitsigns marks added, changed, and removed lines beside your code. A **hunk**
is a group of nearby changes that you can preview, stage, or reset together.

## Brief usage

Open a Git-tracked file, for example `nvim src/main.c` inside your repository.
Change a line and return to normal mode. Signs update automatically, including
unsaved edits. Press **Space h p** to preview the hunk. Move the cursor to close
the popup; invoking the preview again enters it, where **q** closes it.

Use **]c** / **[c** to visit the next/previous hunk, then **Space h s** to stage
the hunk under the cursor. Once the signs update, the same shortcut on a hunk
with only staged changes unstages it. Staging updates Git's index using buffer
contents; it does not save the file or create a commit. Use **:w** when you want
to save your buffer to disk. You can inspect the result with `git diff --cached`
in a terminal.

For example, if you changed two return values but want to stage just one,
select its line with **V** and press **Space h s**. Visual actions operate on
whole selected lines, including part of a hunk; they do not stage individual
characters. **Space h r** instead discards unstaged changes in the hunk or
selection from the buffer, restoring the index version. Normal-mode **u**
can undo that reset; saving later writes the result to disk.

Press **Space h b** on a committed line to see its author and commit in a popup.
Move the cursor to dismiss it, or invoke it again to focus the popup and press
**q**. Newly changed lines may show as not committed yet.

## Commands and shortcuts

`<leader>` is **Space**. All custom mappings below have a `desc` and are local
to buffers where Gitsigns attaches. Mode **n** means normal; **x** means visual
selection (not select mode).

| Mode | Keys | Command / effect |
| --- | --- | --- |
| n | `]c` / `[c` | `:Gitsigns nav_hunk next target=all` / `:Gitsigns nav_hunk prev target=all`; visit staged and unstaged hunks. |
| n | `Space h p` | `:Gitsigns preview_hunk`; preview the current hunk. |
| n, x | `Space h s` | `:Gitsigns stage_hunk`; stage the hunk/selected lines, or unstage when only staged changes occupy that range. |
| n, x | `Space h r` | `:Gitsigns reset_hunk`; discard unstaged buffer changes in the hunk/selected lines. |
| n | `Space h b` | `:Gitsigns blame_line`; show line blame on demand. |

In visual mode the shortcuts pass the selected line range; the equivalent Ex
commands use `:'<,'>Gitsigns stage_hunk` or `:'<,'>Gitsigns reset_hunk`. When staged
and unstaged changes overlap, stage/preview prioritizes the unstaged hunk.
Navigation accepts counts such as `2]c` and wraps according to `wrapscan`.
In a diff window, `]c` and `[c` retain Neovim's native diff motions and counts.

Additional built-in commands have no custom mappings:

| Command | Effect |
| --- | --- |
| `:Gitsigns diffthis` | Compare the buffer with the index in a split. Close the comparison window with `:q`. |
| `:Gitsigns diffthis HEAD` | Compare the buffer with the last commit. Close the comparison window with `:q`. |
| `:Gitsigns toggle_signs` | Hide/show gutter signs for the session. |
| `:Gitsigns toggle_current_line_blame` | Toggle automatic blame text after pausing on a line; initially off. |
| `:help gitsigns` | Open plugin help; close the help window with `:q`. |

If help is unavailable before opening a file, use `:Lazy load gitsigns.nvim`
first. This release has no dedicated health-check module; use `:checkhealth lazy`
for manager requirements and `:Lazy` to inspect the installation.
Gitsigns has no main window to open or close: signs live alongside your file.

## Dependencies and configuration

`lewis6991/gitsigns.nvim` requires Neovim **0.9.0 or newer** and a recent **Git**
executable for repository information, blame, and index updates. This machine
has Neovim 0.12.5 and Git 2.55.0. It requires no additional plugins, external
diff tools, icons, or special font.

The initial installation is **v2.1.0**, with its exact commit generated into
`lazy-lock.json` by lazy.nvim. Its independent checkout lives under
`~/.local/share/nvim/lazy-selected/gitsigns.nvim`. The previous installation
under `~/.local/share/nvim/lazy/` remains preserved.

`lua/plugins/gitsigns.lua` contains the specification and shortcuts, explicitly
imported by `lua/config/lazy.lua`.

| Setting | Value | Reason |
| --- | --- | --- |
| `version` | `"*"` | Follow stable releases on manual updates; record the exact commit in the lockfile. |
| `event` | `BufReadPre`, `BufNewFile` | Load when opening/creating a file so markers appear automatically. |
| `cmd` | `Gitsigns` | Allow explicit commands to load the plugin before opening a file. |
| `opts.on_attach` | Callback installing buffer-local mappings | Keep Git controls scoped to files the plugin can track. |
| Mapping `buffer` | Attached buffer number | Avoid global Git shortcuts in directory or unrelated buffers. |
| Mapping `desc` | Description of each action | Explain mappings in Neovim and any future shortcut helper. |
| Navigation `target` | `"all"` | Visit both staged and unstaged hunks. |

Other behavior uses upstream defaults: attachment is automatic for eligible
Git-tracked files, and repository/index changes refresh signs, including when
you stage from a terminal. Files outside Git, ignored files, untracked files,
and buffers longer than 40,000 lines do not receive normal automatic attachment.
For a new file, save it and run `git add path/to/file`, then reopen it if needed.

Default signs use **┃** for additions/changes (different highlight colors),
**_** for deletions, **‾** for deletions above the first line, and **~** for
changes with deletions. Staged changes use separate, dimmer highlights; an
unstaged sign takes precedence where they overlap. Neovim's default
`signcolumn=auto` shows the gutter only when needed. Blame text, whole-line and
line-number highlighting, and inline word diffs start disabled. Normal editing
never stages, resets, saves, or commits automatically.

## Disable or remove

Remove `{ import = "plugins.gitsigns" }` from `lua/config/lazy.lua` and restart
Neovim. Signs, commands, and Git shortcuts stop loading. Use `:Lazy clean` to
remove the unused checkout from `lazy-selected` if desired. The specification
can stay on disk because imports are explicit. Update the README and feature
selection record alongside the change. The preserved old installation and
`.backups/` are unaffected.
