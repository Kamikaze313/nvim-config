# Which-key: discover your shortcuts

Which-key displays available keys and their descriptions when you pause during
a shortcut. It reads the existing mappings, including lazy-loaded Telescope
shortcuts, Gitsigns actions local to the current buffer, Space e for Explorer,
and the Appearance group at Space u (Space u c chooses a colorscheme).

## Brief usage

Start `nvim` in a project directory. In normal mode, press **Space** and wait
about **200 ms**. The popup shows the available groups. Press **f** to enter
**Find**, then **f** again to run **Find files**. Telescope opens; type part of a
filename and press **Enter** to open it, or **Ctrl-c** to close the picker.

For Git actions, open a tracked file, press **Space h**, and pause to see
**Git hunks**. Press **p** to preview the current hunk. Moving the cursor closes
that preview. In visual mode, **Space h** shows the stage/reset actions for
selected lines. Git actions appear only in buffers where Gitsigns attaches.

Inside which-key, press the displayed next key to continue a shortcut or
**Esc** to cancel and close the popup. **Ctrl-d** / **Ctrl-u** scroll the popup
down/up when needed; **Backspace** returns to the previous prefix. Completing a
shortcut closes the hints and runs its existing action. The popup is a key
guide; you do not select entries with j/k.

## Commands and keys

There are no new custom action mappings. These are popup triggers and upstream
controls; **n** means normal mode and **x** means visual selection mode.

| Mode / context | Keys or command | Effect |
| --- | --- | --- |
| n | `Space`, then pause | Show available leader shortcuts and group labels. |
| n | `Space f`, then pause | Show the existing Telescope search shortcuts. |
| n, x; Gitsigns attached | `Space h`, then pause | Show Git hunk actions available in the current mode. |
| Popup | Displayed next key | Continue the shortcut or execute its action. |
| Popup | `Esc` | Cancel and dismiss hints. |
| Popup | `Backspace` | Return to the previous prefix. |
| Popup | `Ctrl-d` / `Ctrl-u` | Scroll down/up. |
| Command | `:WhichKey` | Open normal-mode key help directly. |
| Command | `:WhichKey n <Space>` | Open leader-key help directly. |
| Command | `:checkhealth which-key` | Check requirements, configuration, and mapping conflicts; close with `:q`. |
| Command | `:help which-key.nvim` | Open plugin help; close with `:q`. |

The health check reports missing optional icon providers even when mapping
icons are disabled. Those notices need no installation in this setup. It also
reports Neovim's native `gc` / `gcc` comment-prefix overlap; these built-in
commands work together as intended. Startup and interactive leader-popup,
Find-to-Telescope, Git-action display, and Esc dismissal checks passed; the
health check found no configuration errors or duplicate mappings.

## Dependencies and configuration

`folke/which-key.nvim` requires **Neovim 0.9.4 or newer**; this machine has
0.12.5. It has **no required plugin dependencies**. Git is used by the existing
lazy.nvim manager for installation and updates. Key labels use ordinary text
and mapping icons are disabled, so no icon plugin or Nerd Font is needed.

The initial installed release is **v3.17.0**. The independent checkout lives at
`~/.local/share/nvim/lazy-selected/which-key.nvim`. The exact installed commit
is generated into `lazy-lock.json` by lazy.nvim. The previous checkout under
`~/.local/share/nvim/lazy/` remains preserved.

The specification lives in `lua/plugins/which-key.lua`, explicitly imported
by `lua/config/lazy.lua`.

| Setting | Value | Reason |
| --- | --- | --- |
| `version` | `"*"` | Follow stable releases on manual updates; record the commit in the lockfile. |
| `event` | `"VeryLazy"` | Set up hints just after startup, once existing mappings are available. |
| `cmd` | `"WhichKey"` | Support explicitly opening the helper before the startup event runs. |
| `opts` | Function returning the options | Build readable labels for special keys and F1–F12. |
| `delay` | `200` milliseconds | Brief pause before hints appear, including built-in help, without changing `timeoutlen`. |
| `icons.mappings` | `false` | Show descriptions without icon dependencies. |
| `icons.keys` | Text names for special keys | Display Space, Ctrl-, Enter, arrows, function keys, etc. without special font glyphs. |
| `spec` Find group | `<leader>f`, normal mode | Label the existing Telescope shortcuts. |
| `spec` Git hunks group | `<leader>h`, normal and visual modes | Label existing buffer-local Gitsigns actions. |
| `spec` Appearance group | `<leader>u`, normal mode | Label the selected colorscheme menu shortcut. |

Group entries describe prefixes rather than defining new action mappings.
Each existing custom action already has a `desc`, which supplies its popup
label. The Space leader is defined in `lua/config/options.lua`.

## Automatic behavior

After loading, which-key discovers mappings and uses its upstream automatic
triggers in normal, visual, select, and operator-pending modes. Its built-in
help also describes native prefixes such as **g**, **z**, and **Ctrl-w**, as
well as marks, registers, operators, motions, text objects, and **z=** spelling
suggestions. These helpers are included in which-key itself. Some visual and
operator help waits for another key before displaying, according to upstream
defaults. Insert and command modes are not added to automatic triggers here.

The classic popup layout, sorting, scrolling keys, and other behavior use
upstream defaults. Pausing shows help; it does not execute an action. Typing a
complete shortcut promptly runs it as usual without requiring the popup.
Use the existing mappings' guides for what each action does.

## Disable or remove

Remove `{ import = "plugins.which-key" }` from `lua/config/lazy.lua`, then
restart Neovim. Shortcut popups and `:WhichKey` stop loading; Telescope, Oil,
and Git action mappings continue working. The specification can remain on
disk because imports are explicit. Optionally use `:Lazy clean` to remove
the unused checkout from `lazy-selected`. Update README.md and the feature
selection record alongside the change. Preserve `.backups/` and the old
installation under `~/.local/share/nvim/lazy/`.
