# Previous setup inventory

Captured before the rebuild on 2026-11-11. Sources: the old `init.lua`,
`lua/config/`, `lua/plugins/`, `lazyvim.json`, and `lazy-lock.json`, all in the
[backup](backup.md). This is configuration evidence, not a usage history.

## Explicit configuration

- LazyVim loaded through lazy.nvim, with periodic plugin update checks enabled
  and update notifications suppressed.
- Extra bundles: Copilot Chat, clangd for C/C++, and TOML.
- Shared system clipboard through `clipboard=unnamedplus`. A Windows clipboard
  provider example was commented out, so it was not active.
- Four-column tabs: `tabstop`, `shiftwidth`, and `softtabstop` set to 4;
  `expandtab=false`; `smarttab=true`. These applied globally.
- Automatic formatting disabled with LazyVim's `vim.g.autoformat=false`.
- Top-right file path and modified indicator through `winbar="%=%m %f"`.
- A workaround forced `winfixbuf=false` on window/buffer entry. It belonged
  to the previous plugin setup and should only return if a concrete issue requires it.
- OneDark with the `darker` style.
- Snacks dashboard with a custom ASCII header; Snacks notifier disabled.
- The preserved LazyVim/Snacks setup supplied the project file sidebar on
  `<leader>e` through Snacks Explorer. This feature is now selected independently;
  see the [Explorer guide](explorer.md).
- Telescope with plenary; the native fzf extension was commented out.
- LazyGit integration with `<leader>lg`.
- 42 header with a configured login/email and `<leader>hdr`; the personal
  values remain in the backup for reuse if selected.
- Norminette plugin configuration entirely commented out. Its old intended
  behavior was running on save and showing up to five errors.
- C/C++ debugging with nvim-dap, a debugger UI, virtual variable values,
  Mason integration, and CodeLLDB. The UI opened/closed with the debug session;
  launching prompted for the executable. Configuration presence does not prove
  that all required dependencies or the adapter worked.
- LeetCode with C as the default language and its notifier disabled. Its
  `hooke` field appears misspelled; it should not be copied into the rebuild.
- `lua/config/highlights.lua` defined three dashboard colors but was not
  explicitly required by the visible startup configuration.
- `lua/plugins/example.lua` returned immediately; the plugins demonstrated
  later in that file were inactive examples.

## Features represented in the previous lockfile

The lockfile also contained completion (`blink.cmp`), snippets,
Treesitter/highlight text objects, Gitsigns, a statusline and buffer tabs,
which-key, Flash, text objects and bracket pairs, formatting, linting,
Trouble diagnostics, session persistence, project search/replace, TODO comments,
Noice, icons, and Lua development support. Some entries may have been stale.
They are offered individually in the [feature menu](features.md).

## Local tools found during inspection

Neovim 0.12.5, Git, ripgrep, fd, clangd, wl-copy, and xclip were on PATH.
Norminette, LazyGit, and StyLua were not found on PATH in this shell. A tool
may still exist in Mason or another location. Clipboard integration still needs
a working display/session and a functional provider.

## Preserved edits and data

Before rebuilding, `lua/plugins/norminette42.lua` had a staged edit disabling
the plugin, and `lua/plugins/stdheader.lua` had an unstaged edit configuring
the header identity and shortcut. Both file contents and the Git index are
in the backup. The live Git index was not changed by the rebuild.

Existing plugins under `~/.local/share/nvim/lazy`, Mason tools, caches, state,
and authentication data were left in place. They are outside the configuration
archive and are not loaded by the new configuration's startup modules.
