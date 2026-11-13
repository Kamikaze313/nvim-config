# mini.pairs: matching brackets and quotes

mini.pairs inserts matching brackets and quotes while you type in insert mode.
It uses the standalone `nvim-mini/mini.pairs` plugin, without the mini.nvim library.

## Brief usage

Open an empty editing buffer and press **i**. Type `print(`: Neovim inserts
`print()` with the cursor between the parentheses. Type `"hello"`, then `)`.
The generated closing quote and parenthesis are skipped as you type, leaving
`print("hello")`. Press **Esc** to leave insert mode. There is no plugin window
to open or close.

| Mode / context | Keys | Effect |
| --- | --- | --- |
| Insert | `(`, `[`, `{` | Insert both sides of the bracket pair, with the cursor inside. |
| Insert | `"`, `'`, backtick | Insert a matching quote pair, or skip its closer when appropriate. |
| Insert, before a generated closer | `)`, `]`, `}`, matching quote | Move past it instead of inserting another closer. |
| Insert, inside an empty pair | `Backspace` | Delete both characters. |
| Insert, inside empty `()`, `[]`, `{}` | `Enter` | Create a blank line inside the pair and put the closer on another line. Existing indentation settings apply. |
| Insert | `Ctrl-v`, then a character | Insert that character literally, bypassing its pair mapping. |
| Insert | `Esc` | Leave insert mode using Neovim's native control. |

For example, type `{` then Backspace to remove the whole empty `{}` pair.
For a single literal `(`, press Ctrl-v then `(`. Enter inside quotes/backticks
uses ordinary newline behavior rather than the bracket expansion above.

## Dependencies, configuration, and automatic behavior

The installed release is **v0.18.0**. It requires **Neovim 0.10+** and has no
additional plugin or external-tool dependencies.
Git is used by the selected lazy.nvim manager to install and update it.
Its independent checkout is `~/.local/share/nvim/lazy-selected/mini.pairs`;
lazy.nvim records its exact version in `lazy-lock.json`.

`lua/plugins/pairs.lua` defines the plugin, explicitly imported by
`lua/config/lazy.lua`.

| Setting | Value / reason |
| --- | --- |
| Repository | `nvim-mini/mini.pairs`: install only the selected pairing module. |
| `version` | `"*"`: follow stable releases on manual updates; pin the installed commit in the lockfile. |
| `lazy` | `false`: set up at startup so the upstream search-prompt exclusions exist before the first Telescope picker opens. |
| `main` | `"mini.pairs"`: identify the setup module explicitly for lazy.nvim. |
| `opts.modes.insert` | `true`: create the upstream editing mappings. |
| `opts.modes.command` | `false`: keep command-line and search input literal. |
| `opts.modes.terminal` | `false`: keep shell/terminal input literal. |

Other pair rules use upstream defaults. Opening pairs are normally skipped
after a backslash; a single quote also skips opening after an alphabetic
character. Thus Python `f'`, `r'`, and `b'` do not automatically add a second
quote; double-quoted forms such as `f"` do. Pairing uses neighboring characters,
without syntax or bracket-balance analysis. It does not handle triple quotes
as a special case or wrap existing selections.

The upstream setup automatically disables pairing in `TelescopePrompt` and
`fzf` buffers. The mappings remain loaded for the rest of the session and
include upstream descriptions; no leader shortcuts are added. Upstream
Backspace/Enter mappings are created only if those keys have no existing mapping.

Use `:Lazy load mini.pairs` to load it explicitly before entering insert mode,
then `:help mini.pairs` for upstream help; close help with `:q`. `:Lazy` shows
its installation state; press `q` to close the manager.

Validation: startup and attached-UI checks passed for bracket/quote insertion,
closing-character skipping, paired Backspace/Enter, literal input, temporary
disabling, command-line/terminal exclusions, and Telescope used before editing.

## Disable or remove

For this session, run `:lua vim.g.minipairs_disable = true`. Set the same flag
to `false` to re-enable. For only the current buffer, use
`:lua vim.b.minipairs_disable = true`, then `false` to re-enable that buffer.

To remove the feature permanently, remove `{ import = "plugins.pairs" }` from
`lua/config/lazy.lua` and restart Neovim. The specification can remain unused
on disk. Optionally use `:Lazy clean` to remove its unused checkout from
`lazy-selected`. Update README.md and docs/features.md alongside removal;
preserve the old installations and `.backups/`.
