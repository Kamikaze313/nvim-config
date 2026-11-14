# Tree-sitter highlighting for Python and Lua

nvim-treesitter manages language parsers and compatible queries; Neovim's built-in
Tree-sitter engine uses them to highlight code by syntax. Python and Lua are the
selected languages. Pyright continues to handle Python types, diagnostics,
completion, and navigation independently. No nvim-lspconfig is required.

## Usage

Restart Neovim, then open `example.py` and enter:

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"
```

Highlighting starts automatically and updates as you type. Functions, parameters,
strings, and keywords receive their corresponding highlight groups; the current
colorscheme determines the actual colors. Lua files, including `init.lua`, work
the same way. Use normal editing controls: **i** to insert, **Esc** to return to
normal mode, **:w** to save, and **:q** to close the file. There is no highlighting
window to open or close and no custom keymap.

To see what Tree-sitter recognizes, move onto `greet` in normal mode and run
**:Inspect**. It lists the highlight groups in the message area; press **Enter**
if prompted to continue. For a structural view, run **:InspectTree**. It opens
and focuses a split: use **j/k** to browse nodes, **Enter** to jump to a node in
the source, and **Ctrl-w w** to switch between the windows. Press **q** while
focused on the tree to close it. These are native Neovim commands, not additional plugins.

## Dependencies and installation

- Neovim **0.12+**, with the built-in Tree-sitter runtime. This device uses 0.12-dev.
- **nvim-treesitter**, on its current `main` API; `lazy-lock.json` records the revision.
- **Python and Lua parsers**, plus their highlight queries. Their revisions are
  selected by the plugin's manifest so the parsers and queries agree.
- **Tree-sitter CLI 0.26.1+** and a **C compiler** to build the parsers.
- **curl** and **tar** to download and unpack parser sources; **Git** for lazy.nvim's
  plugin downloads. These tools and the compiler were already installed here.
- Internet access for explicit installation/update commands, not ordinary editing.

There are no required helper plugins or special fonts. The CLI is a separate
executable, not a language server. Once installed, parsers run inside Neovim.

On this Ubuntu 22.04 device, CLI **0.26.1** is built from the official release
source and installed at `~/.local/bin/tree-sitter`, already on PATH. The official
prebuilt 0.26.1 Linux binary requires a newer glibc. Rust and Cargo are needed
only for building the CLI from source; the temporary build toolchain is under
`/tmp`, and Neovim does not depend on it after the executable is installed.

On a new device:

1. Install Neovim 0.12+, Git, curl, tar, a C compiler, and Tree-sitter CLI 0.26.1+
   using a compatible package/release. Follow upstream's recommendation to avoid
   the npm installation route. Check `tree-sitter --version` in your shell.
2. If the available CLI binary needs a newer glibc, use a current Rust toolchain
   from [rustup](https://rustup.rs/) and build the official source instead:

   ```sh
   rustup toolchain install stable --profile minimal
   cargo +stable install --git https://github.com/tree-sitter/tree-sitter \
     --tag v0.26.1 --locked --root ~/.local tree-sitter-cli
   ```

   Keep `~/.local/bin` on PATH. Future plugin updates may raise the minimum CLI
   version; check `:checkhealth nvim-treesitter` after updating.
3. In Neovim, run **:Lazy install**, wait, and restart to load the selected plugin.
4. Run **:TSInstall python lua**. Wait for both installations to finish, then
   restart or reopen your source buffer to start highlighting.
5. Run **:checkhealth nvim-treesitter** and try the example above. Close the health
   report with **:q**.

The plugin lives at `~/.local/share/nvim/lazy-selected/nvim-treesitter/`.
Parsers, queries, and revision records live under
`~/.local/share/nvim/treesitter-selected/` (`parser/`, `queries/`, and `parser-info/`).
Upstream uses Neovim's cache directory for temporary parser downloads. Previous
plugins and site data are preserved; this feature does not clean them.

## Commands and maintenance

Run these from normal mode by typing `:` followed by the command and Enter.

| Command | Effect |
| --- | --- |
| `:TSInstall python lua` | Download/build missing selected parsers and install their queries. |
| `:TSUpdate python lua` | Update already-installed selected parsers to the plugin's manifest revisions. |
| `:TSInstall! python lua` | Reinstall parsers and queries, including after restoring an older plugin revision. |
| `:checkhealth nvim-treesitter` | Check tools, parser loading, and queries; `:q` closes the report. |
| `:TSLog` | Show parser installation/update messages; `:q` closes the log. |
| `:Inspect` | Show highlight groups at the cursor; press Enter if prompted to continue. |
| `:InspectTree` | Open/focus the native syntax-tree split; `j/k` browse, Enter jumps to source, `Ctrl-w w` switches windows, `q` in the tree closes it. |
| `:lua vim.treesitter.stop()` | Stop Tree-sitter highlighting in the current buffer. |
| `:lua vim.treesitter.start()` | Resume it in the current supported buffer. |

Parser installation/updates run asynchronously. Wait for completion before
quitting; use `:TSLog` if a download or compilation fails. The plugin build hook
runs `:TSUpdate python lua` during an explicit lazy.nvim install/update. It does
not install missing parsers or run during normal startup. After `:Lazy restore`,
use `:TSInstall! python lua` to rebuild against the restored manifest, then restart.

On this Neovim 0.12-dev build, the current upstream health checker reports
`is not in runtimepath` for the install directory even though it is present:
it compares a path with a trailing slash to paths without one. The parser paths
and live highlighting were verified separately. To inspect the actual paths,
run `:lua vim.print(vim.api.nvim_get_runtime_file('parser/python.so', true))`
(or replace `python` with `lua`); the first match should be under
`treesitter-selected/parser/`. The health report's parser/query checks pass.

## Configuration and automatic behavior

All settings live in `lua/plugins/treesitter.lua`, imported explicitly by
`lua/config/lazy.lua`.

| Setting | Why it exists |
| --- | --- |
| `branch = "main"`, `version = false` | Use the current Neovim 0.12 API; the lockfile pins the installed commit. |
| `lazy = false` | Load at startup, as required by upstream. |
| `build = ":TSUpdate python lua"` | Keep selected installed parsers compatible when explicitly updating the plugin. |
| `opts.install_dir` | Store parsers/queries separately in `stdpath("data") .. "/treesitter-selected"`; prepend it to the runtime path. |
| `SelectedTreesitterHighlight` augroup, `clear = true` | Own the autocmd and avoid duplicate callbacks on configuration reloads. |
| `FileType`, patterns `python` and `lua` | Start native highlighting when opening or creating selected source buffers. |
| Empty `buftype` check | Exclude special buffers such as pickers and terminals. |
| Protected `vim.treesitter.start()` call | Keep files editable if parsers are missing/broken; show installation guidance. |

No automatic downloads, Tree-sitter indentation, structural folds, text-object
plugins, custom shortcuts, or additional languages are configured. A parser
alone does not activate highlighting for an unselected filetype. To add a future
selected language, install its parser and add its filetype to the autocmd and
parser name to the update hook, then update README.md and docs/features.md.

Validation: startup, parser update hook, Python/Lua parsing and function/string
highlight captures, buffer stop/start, special-buffer exclusions, and coexistence
with Pyright/Blink were checked. Only the known upstream health path comparison
above reports an error.

## Disable

For the current buffer, use `:lua vim.treesitter.stop()`; use
`:lua vim.treesitter.start()` to resume. Reopening the buffer/restarting enables
highlighting again.

To disable this feature persistently, remove `{ import = "plugins.treesitter" }`
from `lua/config/lazy.lua` and restart. Update README.md and docs/features.md.
The plugin, CLI, and parsers may remain installed. Keep `.backups/`, previous
plugin installations, and Git history/index intact.
