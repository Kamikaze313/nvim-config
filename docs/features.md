# Choose your Neovim features

Status: lazy.nvim is selected strictly as the plugin manager. Telescope with
its required plenary dependency is selected for search, Oil for directory editing,
Gitsigns for Git change markers and hunk actions, which-key for shortcut hints,
and Snacks Explorer for a project sidebar with its required bundled picker.
Default and Everforest are selected for theme switching; fonts use Kitty's existing chooser.
A native bottom terminal is selected on `Ctrl-/` in normal mode and terminal input;
`Esc Esc` enters terminal normal mode. No new plugin is required.
Requested quit-command display cleanup clears retained :q text after a successful close.
mini.pairs is selected for insert-mode bracket and quote pairing.
Other optional features remain proposals and will be introduced one at a time for yes/no.
Individual parts of a row can be selected separately.

## First choice: plugin management

| Choice | Pitch | Tradeoff |
| --- | --- | --- |
| **lazy.nvim — selected** | **Your plugin control panel.** Install, update, inspect, and restore pinned plugin versions through `:Lazy`. | One external manager; convenient dependency ordering, build hooks, and loading on demand. |
| **Built-in `vim.pack`** | **Keep it native.** Neovim 0.12 includes plugin installation, updates, and a lockfile. | Good for a small setup; more manual work for dependency ordering, build hooks, and loading on demand. See `:help vim.pack`. |
| **Manual packages** | **Own every step.** Place plugins in Neovim's `pack/` directories yourself. | You manage cloning, updates, dependencies, and version pinning; more maintenance than necessary here. |

lazy.nvim is a plugin manager. LazyVim is a distribution built on that manager,
with many plugins and defaults already chosen. The previous setup used both.
Using lazy.nvim alone lets this rebuild stay explicit and individually documented.
See [the selected manager configuration](plugin-manager.md) for its exact behavior.

## Feature menu

"Previous" means found in configuration or the saved plugin lockfile, not proof
that a feature was used or functioning. "Suggested" means a useful option for
the rebuild. See [the inventory](previous-setup.md) for the evidence and caveats.

| ID | The pitch | Possible implementation / requirements | Previous or suggested |
| --- | --- | --- | --- |
| 1 | **Make every edit comfortable.** Line numbers, readable search, predictable splits, and visible copied text. | Built-in settings and a yank-highlight autocommand; shortcuts and leader chosen explicitly. | Suggested foundation; old LazyVim also provided defaults. |
| 2 | **Copy here, paste anywhere.** Share Neovim's clipboard with desktop apps. | Built-in `unnamedplus`; a working clipboard provider is required. | Previously explicit. |
| 3 | **Indent your way.** Four-column real tabs for your 42 C work, with language-specific rules if wanted. | Built-in indentation settings; choose global or C-only behavior. | Previously global; format-on-save was disabled. |
| 4 | **Choose your editor's colors.** Switch between the built-in Default theme and Everforest. | **Selected: Default + `neanias/everforest-nvim`.** `Space u c` / `:Theme` remembers the choice. Kitty's existing font chooser controls terminal fonts. [Usage guide](appearance.md). Statusline, tabs, and winbar remain unselected. | OneDark and winbar were explicit before the rebuild; Default/Everforest selected now. |
| 5 | **Find anything in seconds.** Search filenames, project text, open buffers, and recent files. | **Selected: Telescope + plenary.** Uses installed ripgrep and fd. [Usage guide](telescope.md). | Telescope was explicit in the old setup. |
| 6 | **Manage folders using Vim editing.** Browse, create, rename, move, and delete files in an editable directory view. | **Selected: Oil.nvim.** No required plugin dependencies. [Usage guide](oil.md). | New selection for this rebuild. |
| 7 | **An editor that understands C/C++.** Jump to definitions, inspect types, rename symbols, and see errors while coding. | Native LSP plus clangd; optional `nvim-lspconfig` and Mason for setup/tool management. | clangd extra explicitly enabled. |
| 8 | **Type less, finish faster.** Completion menus and reusable snippets. | `blink.cmp`; optionally `friendly-snippets`. | Both in old lockfile. |
| 9 | **Read code by its structure.** Rich highlighting and precise selections of functions or arguments. | Treesitter and optional text objects; selected parsers may require a compiler. | Both in old lockfile. |
| 10 | **Your 42 header, instantly.** Insert and maintain your school header with one command. | `42paris/42header`; reuse the identity saved in the backup if selected. | Explicit; old shortcut was `<leader>hdr`, plus the plugin's F1 default. |
| 11 | **Catch Norm errors early.** Show 42 style violations while you work. | Norminette integration plus the external `norminette` command; choose manual or save-time checks. | Previously configured, but disabled before the backup. |
| 12 | **Watch your program think.** Breakpoints, stepping, variables, and a debugger panel for C/C++. | `nvim-dap`, UI, virtual text, required UI dependencies, and CodeLLDB. | Explicitly configured; rebuilt setup will need adapter validation. |
| 13 | **Git without leaving your code.** Inspect line changes and stage individual hunks. | **Selected: Gitsigns.nvim.** Requires Git; no plugin dependencies. [Usage guide](gitsigns.md). A full LazyGit interface remains optional and unselected. | Gitsigns in old lockfile; LazyGit previously explicit. |
| 14 | **Make shortcuts discoverable.** See available commands when you pause after the leader key. | **Selected: which-key.nvim.** No required plugin dependencies or special font. [Usage guide](which-key.md). | In old lockfile. |
| 15 | **Small editing superpowers.** Automatic bracket pairs, comments, better text selections, and fast jumps. | **Selected: standalone `mini.pairs`** for insert-mode brackets/quotes, with no additional dependencies. [Usage guide](pairs.md). Built-in comments, `mini.ai`, and `flash.nvim` remain separately selectable. | Related plugins in old lockfile; pairing selected now. |
| 16 | **Clean code on your terms.** Format on command, view lint results, and browse all project diagnostics. | Optional `conform.nvim`, `nvim-lint`, and Trouble; tools depend on language. Save-time formatting requires an explicit choice. | In old lockfile; automatic formatting explicitly disabled. |
| 17 | **Pick up where you left off.** Restore sessions and open a personal welcome screen. | Optional `persistence.nvim` and Snacks dashboard. | Persistence in lockfile; custom dashboard explicit. |
| 18 | **Practice without switching apps.** Solve LeetCode problems inside Neovim, using C by default. | `leetcode.nvim`, its required UI/parser dependencies, and LeetCode authentication. | Explicitly configured. |
| 19 | **An AI partner inside the editor.** Ask about selected code and optionally get inline suggestions. | Copilot Chat / Copilot as selected; account access and service eligibility required. | Copilot Chat extra explicit. |
| 20 | **Give every language the right tools.** Add TOML, Lua, or other languages you use. | Native LSP, chosen servers, parsers, and optional formatters per language. | TOML extra explicit; Lua tooling in old lockfile. |
| 21 | **Change a project in one pass.** Search and replace across files, and surface TODO notes. | Optional `grug-far.nvim` and `todo-comments.nvim`; project search uses ripgrep. | Both in old lockfile. |
| 22 | **Polish the interface.** Floating command input, notifications, and icons. | Optional `noice.nvim`, Snacks notifications, and `mini.icons`; some icons need a Nerd Font. | Noice/icons in lockfile; Snacks notifications explicitly disabled. |
| 23 | **Keep your project tree beside your code.** Browse folders and open files from a left sidebar on Space e. | **Selected: Snacks Explorer + its bundled picker.** Uses installed fd/Git; no additional plugins or special font. [Usage guide](explorer.md). | Restores the sidebar from the previous LazyVim setup. |
| 24 | **Run commands beside your code.** Toggle a reusable shell at the bottom with Ctrl-/. | **Selected: Neovim's built-in terminal.** Esc Esc enters normal mode while keeping the pane open. Requires the configured shell; no plugin dependency. [Usage guide](terminal.md). | Explicitly selected for this rebuild. |

We are considering common/general packages one at a time before language-specific
tools. Everything remains individually selectable, including visual choices.
The Space leader supports the selected Telescope shortcuts; the other editing
basics in row 1 have not been selected.

## Selection record

| Decision | Status |
| --- | --- |
| Back up previous configuration | Complete; archive verified byte-for-byte. |
| Create documented plain-Neovim foundation | Complete. |
| Choose plugin manager | lazy.nvim selected as manager only; no distribution imports. Missing plugins need an explicit `:Lazy install` on each new device; see [setup instructions](plugin-manager.md#on-a-new-device). |
| Themes and font controls (row 4) | Default/Everforest menu selected with persistence and true-color rendering. Fonts use the existing Kitty chooser; no terminal font is changed automatically. |
| File and text search (row 5) | Telescope selected, with required plenary dependency and Space leader shortcuts. |
| Directory editing (row 6) | Oil selected, with `-` to open a directory and confirmation before applying edits. |
| Git change markers and hunk actions (row 13) | Gitsigns selected, with automatic signs and buffer-local navigation, preview, stage/reset, and blame shortcuts. LazyGit remains unselected. |
| Shortcut discovery (row 14) | which-key selected, with a 200 ms popup delay, Find/Git hunk group labels, and plain-text key labels. No extra plugins or action shortcuts. |
| Automatic pairs (part of row 15) | Standalone mini.pairs selected, set up at startup with upstream pair/Backspace/Enter behavior so search-prompt exclusions work on first use. Command-line and terminal pairing are disabled; other row 15 enhancements remain unselected. |
| Project file sidebar (row 23) | Snacks Explorer selected with its bundled picker, Space e toggle, and Git-root/cwd browsing. Oil still handles directory buffers; Telescope remains the search tool. Other Snacks features are not enabled globally. |
| Bottom terminal (row 24) | Native terminal selected on `Ctrl-/` in normal mode and terminal input, plus `:BottomTerminal`, initially 12 rows high. Hiding preserves the shell; `Esc Esc` enters terminal normal mode without hiding. Both Ctrl-/ and its Ctrl-_ terminal encoding are mapped. |
| Quit-command display cleanup | Requested fix: clear retained `:q` / `:quit` text after its window closes successfully, preserving failed-quit errors. Native autocommand; [usage guide](command-line.md). |
| Other optional features | Awaiting selection, one package at a time. |

When selected, expand each feature's documentation with its exact settings,
dependencies, file paths, commands, keymaps, automatic actions, a brief usage
guide with an example, and disabling steps.
