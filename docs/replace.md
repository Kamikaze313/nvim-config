# Visual find and replace with grug-far

**Space s r** opens a form for the current saved file. **Space s R** opens it
for the current file's nearest Git root, or the working directory outside Git.
The form appears in a right split with Search, Replace, Files Filter, Flags,
and Paths inputs, plus a live preview. Paths shows the chosen scope and is
editable. Opening a panel does not change Neovim's working directory.

## Brief usage

For example, save `main.c` with `:write`, then press **Space s r** in normal mode.
The panel starts in insert mode in Search. Type `old_function`, press **Esc**,
then **Tab** to reach Replace and **i** to edit it. Type `new_function` and press
**Esc**. Review the preview, then press **Space r** inside the panel to replace
all matches in the chosen scope. Press **q** in normal mode to close the panel.
Closing without triggering Replace leaves the source files unchanged.

For a project replacement, save any edited source buffers and press **Space s R**.
Set Files Filter to `*.c` to limit matches to C files; edit Paths to target a
specific directory instead. Type one filter per line when using multiple filters.
The default `--fixed-strings` in Flags treats punctuation such as `.` and `(`
literally. Remove it for ripgrep regex syntax, add `--ignore-case` for insensitive
matching, or `--word-regexp` for whole words. These are ripgrep expressions, not
Vim's `:substitute` regex syntax.

## Commands and controls

Global custom mappings are **normal mode** only and have `desc` fields:

| Keys | Description / scope |
| --- | --- |
| `Space s r` | `Find and replace in current file`; requires an existing, saved ordinary file. |
| `Space s R` | `Find and replace in project`; nearest Git root, otherwise cwd. |

The Search / replace prefix is labeled by which-key. Current-file mode asks
you to save an edited buffer or open a saved file before proceeding; it never
falls back to a wider scope for unnamed buffers, directory buffers, or terminals.

These controls apply **inside the form in normal mode**, unless specified:

| Keys | Action |
| --- | --- |
| `i` / `Esc` | Enter/leave insert mode to edit an input. |
| `Tab` / `Shift-Tab` | Move to the next/previous input; press `i` to type. |
| `Space r` | Apply Replace to all matches in the current scope. |
| `q` | Close and delete the form buffer and close its split. |
| `j` / `k` | Move through the form/results. |
| `Enter` on a result | Jump to that source location. |
| `g?` | Open the full action help; `q` or `Esc` closes help. |
| `Ctrl-w w` | Switch between the source and panel windows (native Neovim). |

Replace and Close are customized through grug-far's `keymaps` options; upstream
creates buffer-local mappings with descriptive `desc` fields and displays them
in the help header. Other actions keep upstream mappings. `<localleader>` is
Neovim's default backslash here: for example, `\l` syncs the current result
line, `\s` syncs all result lines, and `\t` opens search history. These sync
actions also write files; consult `g?` before using them. Normal-mode `u` edits
the form's text history; it is not a project-wide replacement undo command.

| Command | Effect |
| --- | --- |
| `:GrugFar` | Upstream command: open the form at cwd with literal matching and no Paths restriction. Use Space s r for current-file scope. |
| `:'<,'>GrugFarWithin` | After a visual selection, open the form restricted to that source range. |
| `:'<,'>GrugFar` | Prefill Search from the visual selection; this alone does not restrict replacement to that selection. |
| `:checkhealth grug-far` | Inspect Neovim/ripgrep and optional integrations; `:q` closes the report. |
| `:help grug-far` | Open upstream documentation; `:q` closes help. |
| `:help grug-far-opts` | Browse configuration options; `:q` closes help. |

## Automatic behavior and disk writes

Typing updates the search and replacement preview after the upstream 500 ms
debounce. Searches start after one character. Opening the form or typing a
replacement does not apply it. **Space r** writes matching files immediately;
there is no later `:write` step. Unlike `:%s/old/new/`, which normally changes
only the first match per line, Replace applies to all matching occurrences.

Ripgrep searches saved files on disk. Save source edits before replacing;
project mode does not automatically save every open buffer. After replacement,
grug-far asks Neovim to reload externally changed files with `checktime`.
Hidden and Git-ignored files follow ripgrep's defaults unless explicitly targeted
or Flags changes them. An explicitly targeted current file can be searched even
when hidden or ignored.

The result display has upstream limits (2,000 matches, long lines truncated).
The Replace action uses the query and scope, not manual deletions from the result
display. Narrow the query when needed; Sync actions have different semantics.
For an empty replacement, upstream asks for confirmation because an empty Replace
input normally represents search-only mode. Add `--replace=` to Flags to preview
deletions. See upstream help for multiline search and selective sync operations.

Upstream search history is saved after Replace, Sync All, and deleting a panel
buffer, under `stdpath("state")/grug-far`. It stores search inputs, not rollback
copies of replaced files. No search panel opens automatically at startup.

## Dependencies and configuration

The installed release is **MagicDuck/grug-far.nvim 1.6.80**. It requires
**Neovim 0.11+** and **ripgrep 14+** (15+
recommended upstream). This device has Neovim 0.12.0-dev and ripgrep 14.1.1 in
`~/.local/bin/`. Git is used for installation by lazy.nvim. There are no required
dependency plugins. The already selected mini.icons provider supplies optional
file icons using the existing Nerd Font support. Only the ripgrep engine is
enabled; ast-grep and its rules engine are not installed for this feature.

`lua/plugins/replace.lua` owns the specification, options, and opening shortcuts.
`lua/config/lazy.lua` imports it explicitly; `lua/plugins/which-key.lua` labels
the Space s group. Its separate checkout lives in
`~/.local/share/nvim/lazy-selected/grug-far.nvim`, and lazy.nvim generates its
installed commit into `lazy-lock.json`. Installation and updates remain manual.

| Setting | Value | Purpose |
| --- | --- | --- |
| `version` | `"*"` | Follow stable releases on manual updates and record the installed commit. |
| `cmd` | `GrugFar`, `GrugFarWithin` | Load on request, including visual-range commands. |
| `main` | `"grug-far"` | Identify the setup module for lazy.nvim. |
| `enabledEngines` | `{ "ripgrep" }` | Use the existing external search dependency. |
| `windowCreationCommand` | `"botright vsplit"` | Show the form beside the original file. |
| `minSearchChars` | `1` | Support replacing single characters. |
| `prefills.flags` | `"--fixed-strings"` | Make literal text matching the initial choice. |
| Opening `prefills.paths` | Escaped current filename or project directory | Show and constrain the initial target, including paths with spaces. |
| `keymaps.replace`, `keymaps.close` | Normal-mode `Space r`, `q` | Keep the main form actions easy to reach. |
| Key `mode`, `desc` | Normal mode and descriptive labels | Document the shortcuts and expose them in which-key. |

To customize, edit `opts` in `lua/plugins/replace.lua` and restart Neovim.
For a bottom panel, change `windowCreationCommand` to `"botright split"`.
For regex by default, set `prefills.flags` to `""`. Add `debounceMs = 250` for
faster previews, or `history = { autoSave = { enabled = false } }` to stop
automatic history saves. Document new settings inline when changing them.
Editing the form's Flags/Paths fields changes just that panel.

Validation: startup and on-demand loading passed. Temporary-file checks covered
literal punctuation and single-character previews, cancelling without writes,
current-file and Git-root replacements, paths with spaces and `#`, unnamed/unsaved
buffer handling, buffer-local mapping descriptions, and help/panel dismissal.

## Disable or remove

Remove `{ import = "plugins.replace" }` from `lua/config/lazy.lua` and the
Search / replace group from `lua/plugins/which-key.lua`, then restart Neovim.
The shortcuts and commands stop loading. The spec and download can remain on
disk. Update README.md and docs/features.md with the selection change; preserve
`.backups/` and the previous plugin installations outside `lazy-selected`.
