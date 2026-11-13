# Automatic completion with blink.cmp

Blink shows suggestions while typing in ordinary editing buffers, using the
attached language server, file paths, and words from buffers. Python's Pyright
provides language-aware suggestions. **Space c c** in normal mode turns Blink
off or back on across all buffers in the current Neovim session.

## Brief usage

Restart Neovim and open `example.py`. Type `import os`, then start a new line
and type `os.pa`. Wait for the menu, use **Ctrl-n / Ctrl-p** or **Down / Up** to
highlight `path`, and press **Ctrl-y** to insert it. A documentation popup
appears after a selection when the provider supplies documentation.

Selecting a suggestion does not change your text until you accept it. With no
selection, **Ctrl-y** selects and accepts the first item. **Ctrl-e** closes the
menu without accepting; **Esc** leaves insert mode and closes completion too.
**Enter** remains a newline, and mini.pairs keeps its existing Enter behavior.

To disable completion, press **Esc**, then **Space c c**. A message confirms
`Completion disabled`. Enter insert mode again and type normally. Press the
same normal-mode shortcut to re-enable it; suggestions resume on typing or
**Ctrl-Space**. The toggle is global to this Neovim process and resets to enabled
on restart. It does not stop Pyright, Flake8, diagnostic display, or native LSP
navigation. Native manual completion (`Ctrl-x Ctrl-o`) is still available.

## Commands and controls

| Mode | Keys / command | Action |
| --- | --- | --- |
| Normal | `Space c c` | Toggle Blink on/off for the session; custom desc: `Toggle completion`. |
| Command | `:CompletionToggle` | The same session-wide toggle, with an enabled/disabled message. |
| Insert | `Ctrl-Space` | Request suggestions; with a menu open, show/hide documentation. |
| Insert | `Ctrl-n` / `Ctrl-p`, `Down` / `Up` | Select next/previous suggestion. |
| Insert | `Ctrl-y` | Accept the selected suggestion, or the first item if none is selected. |
| Insert | `Ctrl-e` | Cancel and close completion. |
| Insert | `Esc` | Leave insert mode and close completion (native). |
| Insert | `Ctrl-b` / `Ctrl-f` | Scroll documentation up/down when open; otherwise fall back. |
| Insert / snippet selection | `Tab` / `Shift-Tab` | Jump through placeholders in an LSP-provided snippet; otherwise use existing behavior. |
| Command | `:checkhealth blink.cmp` | Inspect Blink's setup; `:q` closes the report. |
| Command | `:BlinkCmp status` | Open the same health report; `:q` closes it. |
| Command | `:help blink-cmp` | Open upstream help; `:q` closes it. |

The insert-mode mappings come from Blink's `default` preset. Blink supplies
their descriptions and falls back to existing mappings when appropriate. With
Blink disabled, its mapping actions fall through to native/other mappings.
The new global mapping is normal-mode Space c c, listed under which-key's Code
group.

## Dependencies and automatic behavior

- **saghen/blink.cmp v1.10.2**, following compatible **1.x** releases, and **Neovim 0.10+**.
  This machine has Neovim 0.12.0-dev. Git/lazy.nvim install the plugin.
- The configured **Lua fuzzy matcher** needs no Rust compiler or native binary
  download. It has fewer ranking/typo-tolerance features than the optional Rust
  matcher; it handles completion without that extra installation step.
- LSP, path, and buffer providers are bundled in Blink. Language-aware Python
  suggestions use the already selected **Pyright** server; see the
  [Python dependency guide](python.md#dependencies-and-installation).
- Existing Nerd Font support renders the menu's kind icons. No new icon plugin,
  completion-source plugin, snippet engine, or snippet pack is installed.

Blink initializes at startup, before the Python setup enables Pyright. On
Neovim 0.11+, Blink's upstream plugin registers its LSP completion capabilities
with `vim.lsp.config('*', ...)`; no manual change to `lsp/pyright.lua` is needed.
Suggestions appear as you type, and documentation appears 500 ms after selection
when available. Buffer words are a fallback when LSP has no results, using the
provider's upstream scope. Path suggestions use Blink's standard path provider.

Only ordinary editing buffers (`buftype == ''`) are eligible. Telescope prompts,
Snacks panels, grug-far's form, Oil, help, and other special buffers are excluded.
Command-line/search completion and terminal completion are explicitly disabled
in Blink. Signature help keeps its existing native behavior. Blink's automatic
bracket insertion is off; mini.pairs handles characters you type. LSP-provided
snippets can still include parentheses and placeholders, expanded by Neovim's
built-in `vim.snippet`; Tab/Shift-Tab navigate those placeholders.

## Configuration and customization

`lua/plugins/completion.lua` contains the entire selection, including the local
`enabled` state and toggle. `lua/config/lazy.lua` imports it explicitly. The
checkout is `~/.local/share/nvim/lazy-selected/blink.cmp`; lazy.nvim generates
the installed commit into `lazy-lock.json`. Old installations remain separate.

| Setting | Value | Reason |
| --- | --- | --- |
| `version` | `"1.*"` | Follow compatible 1.x releases on manual updates. |
| `lazy` | `false` | Initialize before LSP clients need completion capabilities. |
| `main` | `"blink.cmp"` | Identify the setup module for lazy.nvim's options. |
| `enabled` | Session flag and ordinary-buffer check | Make the global toggle apply to Blink without enabling it in tool windows. |
| `keymap.preset` | `"default"` | Ctrl-n/p selection, Ctrl-y acceptance, and Enter as newline. |
| `completion.list.selection` | `preselect = false`, `auto_insert = false` | Keep source text unchanged while browsing. |
| `completion.documentation.auto_show` | `true` | Show documentation after selecting an item. |
| `completion.accept.auto_brackets.enabled` | `false` | Leave typed bracket pairing to mini.pairs. |
| `sources.default` | `lsp`, `path`, `buffer` | Use the selected completion sources without snippet bundles. |
| `fuzzy.implementation` | `"lua"` | Avoid a native download or compilation dependency. |
| `cmdline.enabled`, `term.enabled` | `false` | Preserve existing command/search and shell input behavior. |
| `init`, `keys` | Command and normal-mode shortcut with descriptions | Offer discoverable enable/disable controls. |

To start disabled every time, change `local enabled = true` to `false` and
update its comment. To change the toggle, edit `<leader>cc` in `keys`. To show
documentation only on Ctrl-Space, set `auto_show = false`. To accept with Enter,
change the keymap preset to `"enter"`; it accepts only a selected item with the
current `preselect = false` setting. Restart after configuration changes.

Validation: startup passed. Real insert-mode checks covered Pyright suggestions,
automatic documentation, selection without insertion, acceptance, cancellation,
immediate/session-wide disable and re-enable, buffer/path suggestions, special
buffer exclusion, and mini.pairs' Enter behavior. Pyright stayed attached while
completion was disabled.

## Disable or remove

For a temporary pause, use Space c c or `:CompletionToggle`. For permanent
removal, remove `{ import = 'plugins.completion' }` from `lua/config/lazy.lua`
and restart Neovim. The command, shortcut, and Blink setup stop loading; Pyright
and Flake8 keep working. Files/downloads can remain on disk. Update README.md
and docs/features.md; preserve `.backups/` and previous plugin installations.
