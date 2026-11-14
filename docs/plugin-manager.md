# lazy.nvim: package management only

The user selected lazy.nvim with a minimal scope: manage plugins that they
choose individually. No LazyVim distribution or feature bundle is imported.

## What is enabled

`init.lua` loads `lua/config/lazy.lua` after the editor configuration modules.
The manager exposes `:Lazy` and manages installation, updates, version records,
dependencies, and plugin loading. The `spec` table explicitly imports
`plugins.telescope`, `plugins.replace`, `plugins.lint`, `plugins.completion`, `plugins.treesitter`,
`plugins.oil`, `plugins.gitsigns`, `plugins.which-key`,
`plugins.explorer`, `plugins.icons`, `plugins.everforest`, `plugins.ayu`, `plugins.vague`, `plugins.embark`, and `plugins.pairs`.
The manager currently lists itself, Telescope, Telescope's required helper plenary,
Oil, Gitsigns, which-key, Snacks (Explorer with its bundled picker), Everforest, Ayu, Vague, Embark,
grug-far, nvim-lint, blink.cmp, nvim-treesitter, and the standalone mini.pairs and mini.icons plugins.
See the [Telescope usage guide](telescope.md), [Oil usage guide](oil.md),
[Gitsigns usage guide](gitsigns.md), [which-key usage guide](which-key.md), and
[Explorer usage guide](explorer.md), [icon guide](icons.md), and [pairing usage guide](pairs.md).
Theme selection and terminal fonts are covered in the [appearance guide](appearance.md).
Visual find/replace is covered in the [replacement guide](replace.md).
Python's Flake8 and native Pyright setup is covered in the [Python guide](python.md).
Automatic completion and its session toggle are covered in the [completion guide](completion.md).
Python/Lua syntax highlighting and parser installation are covered in the [Tree-sitter guide](treesitter.md).

Dependencies: Neovim with LuaJIT and Git. The existing manager checkout was
copied into the new plugin directory; no download was needed. On a fresh machine,
the bootstrap clones the manager's stable branch from
`https://github.com/folke/lazy.nvim.git`. A failed clone reports an error and
returns to the editor instead of exiting it.

## Every configured choice

| Setting | Value | Reason |
| --- | --- | --- |
| `plugin_root` | `stdpath("data") .. "/lazy-selected"` | Directory for this rebuild's manager and selected plugins. |
| `lazypath` | `plugin_root .. "/lazy.nvim"` | Load the manager's separate checkout, or bootstrap it there when absent. |
| `rtp:prepend(lazypath)` | Manager directory first in the runtime path | Make its Lua module available. |
| `spec` | Explicit imports of `plugins.telescope`, `plugins.replace`, `plugins.lint`, `plugins.completion`, `plugins.treesitter`, `plugins.oil`, `plugins.gitsigns`, `plugins.which-key`, `plugins.explorer`, `plugins.icons`, `plugins.everforest`, `plugins.ayu`, `plugins.vague`, `plugins.embark`, and `plugins.pairs` | Load only the selected feature specifications. |
| `root` | `stdpath("data") .. "/lazy-selected"` | Keep the rebuild's plugins separate from previous plugin installations. |
| `local_spec` | `false` | Prevent project `.lazy.lua` files from extending the selected plugin list. |
| `install.missing` | `false` | Install declared plugins explicitly, not during normal startup. |
| `checker.enabled` | `false` | No background update checks. |
| `change_detection.enabled` | `false` | No automatic plugin-spec reloading or config-change notifications; restart after edits. |
| `rocks.enabled` | `false` | No LuaRocks/toolchain setup unless a future selected plugin requires it. |

Other manager options use upstream defaults. In particular, version records
live in `~/.config/nvim/lazy-lock.json`. The manager adjusts runtime/package
loading as part of its normal operation and preserves built-in runtime plugins.
Future plugins can load on commands, filetypes, events, or startup according to
their individual requirements; there is no blanket lazy-loading rule.
Telescope loads on first use. Oil loads at startup, as recommended upstream,
so directory buffers work correctly even when passed on Neovim's command line.
Gitsigns loads on `BufReadPre`, `BufNewFile`, or an explicit `:Gitsigns` command;
it automatically attaches to eligible Git-tracked files.
Which-key loads on `VeryLazy` just after startup, or on `:WhichKey`, to display
shortcut hints from the existing mappings.
Snacks is set up early at startup as recommended upstream, with only Explorer
and its required picker enabled. The sidebar opens on `Space e`; Oil keeps
handling directory buffers. Explorer uses bundled input/window/file-operation
helpers on demand without replacing general input or selection dialogs.
The standalone mini.icons provider loads before Snacks as its explicit dependency
and supplies Explorer's file/folder icons. It does not import other mini modules.
Everforest loads on `:colorscheme everforest`; Ayu loads on `:colorscheme ayu`,
`ayu-dark`, `ayu-light`, or `ayu-mirage`; Vague loads on `:colorscheme vague`;
Embark loads on `:colorscheme embark` and is named `embark` in the manager.
This includes when `:Theme` applies them or the saved theme is restored at startup.
Default is built into Neovim.
mini.pairs sets up at startup and creates its upstream insert-mode
pair/Backspace/Enter mappings. Early setup lets its upstream Telescope prompt
exclusion work even when search is used first. Command-line and terminal pairing
are disabled.
grug-far loads on its replacement shortcuts or `:GrugFar` / `:GrugFarWithin`.
It uses the existing ripgrep executable and optional mini.icons provider, with
no additional dependency plugins. Searches and change previews update as typed;
the user explicitly triggers replacement to write affected files.
nvim-lint loads for Python or `:Flake8` and runs the external Flake8 tool on
buffer entry/save or explicit requests. Pyright uses Neovim's native LSP;
its server is installed separately through npm and is not a lazy.nvim plugin.
Blink initializes at startup before native LSP clients start, so its upstream
plugin can advertise completion capabilities through `vim.lsp.config('*', ...)`.
Its bundled Lua matcher and LSP/path/buffer sources require no helper plugins,
native binary downloads, or Rust compiler. Space c c toggles it for the session.
Tree-sitter loads at startup as required upstream. A FileType autocmd starts
native highlighting for Python/Lua source buffers. Its build hook runs
`:TSUpdate python lua` during explicit plugin installation/updates, updating only
already-installed selected parsers. First-time installation uses
`:TSInstall python lua`; wait for completion before restarting. No parsers are
downloaded at ordinary startup or when opening files. Parsers and queries are
stored in `~/.local/share/nvim/treesitter-selected/`, preserving the old site data.

The manager itself does not configure editing shortcuts, a theme, completion, language
servers, a dashboard, or formatting. No custom keymap opens its interface; use
`:Lazy`. Its own window has built-in controls available through `?`.

## Commands

Brief usage: open `:Lazy` to inspect the selected plugins, and press `q` to
close its window. After adding a selected plugin's specification, run
`:Lazy install` to download it. For maintenance, use `:Lazy check` to inspect
available updates and `:Lazy update` when you want to apply them.

| Command | Effect |
| --- | --- |
| `:Lazy` | Open the manager. |
| `:Lazy install` | Install missing plugins from the selected specification. |
| `:Lazy check` | Fetch information about available updates without applying them. |
| `:Lazy update` | Update selected plugins, including the manager, and write their versions to the lockfile. |
| `:Lazy restore` | Restore installed plugins to the versions recorded in the lockfile. |
| `:Lazy clean` | Remove unused plugin directories from the new `lazy-selected` directory. |
| `:checkhealth lazy` | Check the manager's requirements and configuration. |

The old feature plugins remain in `~/.local/share/nvim/lazy/`; the new root
keeps them out of the manager's cleanup list. The manager's separate checkout
also allows updates without changing the previous setup's copy of lazy.nvim.

Adding a feature means documenting its specification and dependencies, installing
it explicitly, and recording its version in `lazy-lock.json`. A lockfile records
versions for restore; it does not force the checkout to that version on every
startup. Keep it in Git; do not edit its generated contents by hand.

## On a new device

The configuration and lockfile do not include downloaded plugins. The bootstrap
installs lazy.nvim itself, but `install.missing = false` leaves the feature
plugins uninstalled until requested. Errors such as `Plugin oil.nvim is not
installed` or `Plugin snacks.nvim is not installed` can therefore appear on the
first startup even when the manager is working.

1. Ensure Neovim with LuaJIT, Git, and access to GitHub are available.
2. Start `nvim`, run `:Lazy install`, and wait for installation to finish.
   Open `:Lazy` to inspect any failed download; press `q` to close the window.
3. Run `:Lazy restore` if you want to match the versions in the copied lockfile.
4. Restart Neovim so startup-loaded plugins such as Oil and Snacks initialize.
5. Press `Space f f`, type `init`, and press Enter to open `init.lua` from this
   configuration directory. `Ctrl-c` closes a Telescope picker in insert mode.
   Press `-` to open Oil and `Ctrl-c` in normal mode to close it.

The install directory is `stdpath("data") .. "/lazy-selected"`, normally
`~/.local/share/nvim/lazy-selected/`. Existing plugins in the separate `lazy/`
directory do not count as installed for this configuration. Preserve that old
directory and `.backups/`.

External search tools must also be installed on the new device: `rg` (ripgrep)
version 14+ for Telescope's text search and grug-far, and `fd` or `fdfind` version 8.4+ for Explorer's
search. Their availability on the previous device does not transfer with this
repository. On this device, fd 10.3.0 and ripgrep 14.1.1 were installed from
their official Linux releases into `~/.local/bin/`, already included in the
shell's `PATH`. Ubuntu 22.04's fd 8.3 package is older than Explorer's required
8.4 minimum. Use `:checkhealth lazy`, and the feature guides' health checks, to
inspect requirements on the current device. Explorer's selected file/folder icons
also need Nerd Fonts 3+ glyph support in the terminal, via a patched font or
symbols fallback; see the [icon guide](icons.md). The current Kitty configuration
uses an installed MonoLisa Nerd Font Mono.
Python support also requires Python, Flake8, Node.js, and the Pyright server on
the new device. `:Lazy install` installs only the nvim-lint adapter; follow
the [Python dependency instructions](python.md#dependencies-and-installation).
Tree-sitter additionally requires Neovim 0.12+, a C compiler, curl, tar, and
Tree-sitter CLI 0.26.1+ in PATH. After installing the plugin, run
`:TSInstall python lua`, wait for both installations to finish, and restart.
See the [Tree-sitter dependency instructions](treesitter.md#dependencies-and-installation),
including the CLI build needed on this Ubuntu 22.04 system.

If a plugin does not appear in `:Lazy` at all, check the explicit imports in
`lua/config/lazy.lua`. Only explicitly selected feature specifications are imported;
putting another file in `lua/plugins/` does not activate it. Files in
`lua/config/` likewise need to be required explicitly. Restart after changing
imports because automatic configuration reloading is disabled.

## Disable or remove

To stop loading the manager and all plugins managed by it, remove or comment
out `require("config.lazy")` in `init.lua`, then restart Neovim. The bootstrap
file and downloaded plugins can remain on disk without being loaded. Update
the README and feature selection record when making that change.

To remove a future feature, remove its plugin specification, restart, and use
`:Lazy clean` to remove its unused checkout. Other selected plugins may still
need shared dependencies. The original backup remains in `.backups/`.
