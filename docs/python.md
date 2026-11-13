# Python: Pyright and Flake8 diagnostics

**Pyright** supplies type checks, hover documentation, definition/reference
navigation, and symbol renaming through Neovim's built-in LSP client.
**Flake8**, connected through **nvim-lint**, reports syntax, name, and style
issues. Both appear through native diagnostics beside your code, with signs
and underlines supplied by Neovim's defaults.

## Brief usage

Restart Neovim and open `example.py`. Type this example:

```python
count: int = "hello"
print(missing_name)
```

Pyright reports the incompatible assignment and undefined name while editing.
Save with `:write`, or press **Space c l** in normal mode, to run Flake8. Its
`F821` finding reports `missing_name`. Pyright and Flake8 can both report the
same problem; source labels distinguish them. Replace `"hello"` with `1`,
replace `missing_name` with `count`, and save to clear these diagnostics.
Neither tool changes or formats your source automatically.

Use **]d / [d** to move to the next/previous diagnostic. **Ctrl-w d** opens the
full message at the cursor; move the cursor to close that popup. **K** displays
documentation for a Python symbol; moving the cursor closes hover as well.
If you focus a popup by invoking it again, use `:q` inside it to close it.
Try a small function and call it: **gd** on the call jumps to its definition,
and **Ctrl-o** returns. **grn** prompts for a new symbol name; Enter applies
the rename and Esc cancels. Save edited buffers after an LSP rename.

## Commands and shortcuts

| Mode / scope | Keys or command | Action |
| --- | --- | --- |
| Normal, Python | `Space c l` / `:Flake8` | Lint current buffer text, including unsaved edits. Mapping desc: `Lint Python with Flake8`. |
| Normal, Pyright attached | `gd` | Jump to definition. Buffer-local desc: `Go to Python definition`. |
| Normal | `Ctrl-o` | Return to a previous jump (native). |
| Normal | `]d` / `[d` | Next/previous diagnostic (native). |
| Normal | `Ctrl-w d` | Full diagnostic message at cursor (native); cursor movement closes it. |
| Normal, Pyright attached | `K` | Hover documentation (native LSP default); cursor movement closes it. |
| Normal, Pyright attached | `grn` | Rename symbol (native LSP default); Enter applies, Esc cancels. |
| Normal, Pyright attached | `grr` | Find references (native); when a quickfix list opens, Enter jumps and `:cclose` closes it. |
| Normal / visual, Pyright attached | `gra` | Available code actions (native); select an offered action or cancel with Esc. |
| Insert, Pyright attached | `Ctrl-x Ctrl-o` | Request native completion manually; Ctrl-n/Ctrl-p select, Ctrl-y accepts, Ctrl-e cancels. |
| Command | `:checkhealth vim.lsp` | Check enabled servers and active clients; `:q` closes the report. |
| Command | `:lua vim.print(vim.lsp.get_clients({ name = 'pyright' }))` | Inspect Pyright clients, including root and settings. |
| Command | `:lua vim.diagnostic.setloclist()` | Put current-buffer diagnostics in a location list; Enter jumps, `:lclose` closes it. |
| Command | `:help diagnostic` / `:help lsp` | Native documentation; `:q` closes help. |

Only Space c l and Python's gd are new custom mappings. The other keys are
Neovim defaults. Space c l does nothing outside ordinary Python buffers.
Automatic suggestions are now supplied by the separately selected **blink.cmp**:
type `os.pa` after `import os`, select with Ctrl-n/Ctrl-p, and accept with Ctrl-y.
**Space c c** toggles completion in normal mode; diagnostics and LSP navigation
continue while it is off. See the [completion guide](completion.md). Formatting,
debugging, and test-running tools remain independent choices.

## Automatic behavior and environments

Pyright starts on Python buffers and updates diagnostics while editing. Basic
type checking is selected, with diagnostics for open files only. Imported
modules are still analyzed as needed. Project `pyrightconfig.json` or
`[tool.pyright]` in `pyproject.toml` can customize checks, paths, and exclusions;
project configuration takes precedence over applicable language-server settings.

Flake8 starts when entering or saving a Python buffer. Manual linting also
checks unsaved text because the adapter sends the buffer through stdin. It
runs in the source file's directory, so it discovers the nearest `.flake8`,
`setup.cfg`, or `tox.ini` configuration. Flake8 itself does not read
`pyproject.toml` without an additional plugin, which is not installed here.
Syntax (`E999`) and undefined/unbound-name findings (`F821`/`F822`/`F823`) use
error severity; other findings retain the adapter's warning severity.

Environment lookup prefers an activated **VIRTUAL_ENV**, then the nearest
project root's **.venv**, then executables on **PATH**. A project marker is one
of `pyrightconfig.json`, `pyproject.toml`, `setup.py`, `setup.cfg`, `tox.ini`,
`.flake8`, `requirements.txt`, `Pipfile`, or `.git`. The nearest marker wins.
The Flake8 helper uses the file's directory when no marker exists; native LSP
can use cwd for a standalone file. Pyright receives the chosen interpreter's
`python` path (or `python3` fallback). Flake8 uses the environment's executable
when installed there, otherwise its PATH installation.

For example, create `project/.venv`, install your project's packages there,
and open a file under a project marker. Pyright can resolve that environment's
imports; install Flake8 there too if the project needs a particular version or
Flake8 extension. Alternatively activate the environment before starting Neovim.
Restart Neovim after changing environments to restart Pyright with the new
interpreter. For a nonstandard interpreter, set `python.pythonPath` explicitly
in the server settings and remove/adjust the `before_init` lookup.

## Dependencies and installation

- **Neovim 0.11+** for `vim.lsp.config`/`enable`; this machine uses 0.12.0-dev.
- **Python 3** (currently 3.10.12) and **Flake8** (currently 7.4.1), already
  available here. Flake8 depends on pycodestyle, pyflakes, and mccabe; its package
  installer supplies them. The existing executable is `~/.local/bin/flake8`.
- **mfussenegger/nvim-lint**, the selected asynchronous adapter. It has no
  additional Neovim-plugin dependencies and uses its upstream master branch,
  with the installed commit recorded by lazy.nvim in `lazy-lock.json`.
- **Node.js** (currently 24.21.0) and **Pyright 1.1.414**, installed with
  `npm install --global pyright` in the user's existing Node installation.
  `pyright-langserver` must be on Neovim's PATH. Changing Node versions through
  nvm may require installing Pyright again for that version.
- Git and network access for initial plugin/server installation. No Mason or
  nvim-lspconfig plugin is required by the native server configuration.

On another device, install the external tools as well as running `:Lazy install`.
One option for isolated Flake8 installation is `uv tool install flake8` when uv
is available; alternatively install it in an activated project environment with
`python -m pip install flake8`. Then install Pyright with the npm command above.
These are setup commands, not commands run automatically by this configuration.
Check `flake8 --version`, `pyright --version`, and `command -v pyright-langserver`
in the shell used to launch Neovim. Pyright and Flake8 are external installations;
their versions are not managed by `lazy-lock.json`.

## Configuration and customization

| Location / setting | Behavior and reason |
| --- | --- |
| `init.lua` | Calls `config.python.setup()` after lazy.nvim to configure diagnostics and enable Pyright. |
| `lua/config/python.lua` | Shared root/environment lookup. `virtual_text.source = 'if_many'` displays messages with provider labels; `float.source = true` labels full messages; `severity_sort = true` prioritizes errors. These native display settings apply to all diagnostic providers. |
| `lsp/pyright.lua` | Server command `pyright-langserver --stdio`, Python-only filetypes, equally ranked root markers, basic/open-file analysis, interpreter lookup before initialization, and buffer-local gd. |
| `lua/plugins/lint.lua` | nvim-lint default branch (`version = false`), Python/Flake8 lazy-loading triggers, Python-only linter selection, dynamic executable, severity adjustment, source-directory cwd, and entry/save autocmds. |
| `lua/plugins/which-key.lua` | Labels Space c as Code without adding actions itself. |
| `lua/config/lazy.lua` | Explicitly imports `plugins.lint`; its checkout is under `~/.local/share/nvim/lazy-selected/nvim-lint`. |

To change a project's style policy, use its own Flake8 configuration. For example:

```ini
# .flake8: allow longer lines in this project only.
[flake8]
max-line-length = 88
```

To adjust type-check strictness, change `typeCheckingMode` in the project
Pyright configuration or `lsp/pyright.lua`. To hide inline messages, set
`virtual_text = false` in `lua/config/python.lua`; navigation and popups still
work. To lint only on save, remove `BufEnter` from the autocmd events in
`lua/plugins/lint.lua`. Restart after configuration edits and keep inline
comments consistent with the new behavior.

Validation: startup passed. Temporary-project checks verified initial/save/manual
Flake8 findings, error severity, unsaved-buffer linting, project `.flake8` settings,
virtual-environment import resolution, Pyright type checks, definition/hover/rename
responses, the diagnostic popup, and clearing diagnostics after fixes.

## Disable or remove

To disable Flake8 integration, remove `{ import = 'plugins.lint' }` from
`lua/config/lazy.lua` and the Code group from `lua/plugins/which-key.lua`, then
restart. To disable Pyright alone, remove `vim.lsp.enable('pyright')` from
`lua/config/python.lua`; Flake8 can keep using that module's helper functions.
To remove this entire Python setup, do both and remove the Python setup call
from `init.lua`. Config files and downloaded tools can remain on disk.
Update README.md and docs/features.md with the selection change; preserve
`.backups/`, the Git index/history, and old plugin installations.
