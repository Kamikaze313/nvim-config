# Icon statusline with lualine

The selected **nvim-lualine/lualine.nvim** plugin displays one bar across the
bottom of Neovim: a colored mode icon on the left, the current filename, and
line:column on the right. Angled ** / ** separators provide the Powerline look.
Colors follow the selected theme. The normal `-- INSERT --` message is hidden
because the bar already identifies the mode.
Lualine merges adjacent sections with identical background colors, hiding their
separator; this can give the built-in Default theme a flatter appearance.

## Brief usage and icon legend

Restart Neovim, then run `nvim init.lua` from this configuration directory.
The **** logo indicates normal mode. Press **i**: the icon changes to the ****
pencil as you enter insert mode. Type a comment, press **Esc**, and the normal
icon returns; `[+]` beside the filename means the buffer has unsaved changes.
Run **:w** to save, or undo the example with **u** in normal mode.

| Icon | Mode | Built-in controls |
| --- | --- | --- |
| **** | Normal, including terminal-normal mode | Navigate with `h/j/k/l`; `i` starts inserting. |
| **** | Insert, including completion | Type text; `Esc` returns to normal mode. |
| **** | Visual character, line, or block selection | Normal-mode `v`, `V`, or `Ctrl-v` starts selecting; move to extend it, `Esc` exits. |
| **** | Select character, line, or block selection | Normal-mode `gh`, `gH`, or `g Ctrl-h` starts Select; typing replaces the selection, `Esc` exits. |
| **** | Replace or virtual Replace | Normal-mode `R` or `gR` starts overwriting; `Esc` exits. |
| **** | Operator pending | Normal-mode `d` waits for a motion such as `w`; `Esc` cancels. |
| **** | Command line, search, or Ex mode | Normal-mode `:`, `/`, or `?` opens the command line; `Enter` executes, `Esc` cancels. |
| **** | Terminal input or shell command | `Ctrl-/` opens the selected bottom terminal; `Esc Esc` leaves terminal input, `Ctrl-/` hides it. |
| ** / ** | More or confirmation prompt | Follow Neovim's displayed prompt controls. |

Try **v**, move with **l**, then press **Esc** to see the selection icon change
back. **Ctrl-w w** switches between existing splits; the one bar updates for
the focused window. **Space u c** changes the theme and the bar follows it.
`[-]` beside the filename means readonly or nonmodifiable; an unnamed buffer
shows `[No Name]`. These filename markers are lualine's defaults.

The bar opens automatically and has no separate window, close action, or new
custom keymaps/commands. **:q** closes the file normally. **:help lualine** opens
upstream help; **:q** closes that help window. All editing controls above are
built into Neovim; the terminal and theme shortcuts are existing selections.

## Dependencies and installation

- Neovim with LuaJIT, lazy.nvim, and Git for installation are already available.
- Nerd Fonts 3+ glyph support is required for the logo, mode icons, and Powerline
  separators. Kitty already uses the installed **MonoLisa Nerd Font Mono**, with
  **0xProto Nerd Font Mono** available for fallback. If symbols show as boxes,
  choose a compatible font with `kitten choose-fonts` in a normal Kitty shell;
  see the [font guide](appearance.md#choose-fonts-in-kitty).
  The Neovim logo uses 0xProto's newer glyph; the remaining selected symbols
  are also present in MonoLisa. Their installed font maps cover every bar icon.
- Lualine has no required helper plugin for this design. Icons are literal font
  characters; no devicons provider, compatibility shim, compiler, language server,
  or additional mini.nvim module is needed.

`lua/plugins/statusline.lua` is explicitly imported in `lua/config/lazy.lua`.
It loads on `VeryLazy` just after startup, after the saved theme has been restored.
Its `init` callback hides the duplicate mode text during startup. Lualine updates
on its default window/buffer/cursor/mode events and periodic refresh; colors
rebuild automatically on colorscheme or background changes. Normal startup does
not install plugins or check for updates.

On a new device, run **:Lazy install** (or **:Lazy install lualine.nvim** for
this plugin alone), wait for completion, and restart. The checkout lives at
`~/.local/share/nvim/lazy-selected/lualine.nvim`; lazy.nvim records its installed
commit in `lazy-lock.json`. Updates remain explicit through lazy.nvim.

Validation passed for full startup and UI rendering, actual normal/insert/Visual
character/line/block/Select/Replace/virtual-Replace/operator-pending/command-line/
terminal transitions, returning to terminal-normal mode, split focus, filename
markers, and all eight supported theme choices. Checks used isolated state/cache
directories and did not change the saved personal theme. Installed font maps
covered all selected glyphs; lazy.nvim added only lualine's version to the lockfile.

## Configuration and customization

Every selected setting is commented in `lua/plugins/statusline.lua`:

| Setting | Purpose |
| --- | --- |
| `mode_icons` and the mode component's `fmt` | Replace each known mode label with its glyph; future unknown modes retain their label. |
| `event = "VeryLazy"` | Display the bar just after startup and theme restoration. |
| `init`: `showmode = false` | Hide the redundant mode message in the command area. |
| `options.theme = "auto"` | Use the current colorscheme's lualine palette or generate matching colors. |
| `options.globalstatus = true` | Let lualine set `laststatus = 3` for one bar across all splits. |
| `section_separators`, `component_separators` | Use angled outer section edges and omit extra component dividers. |
| `sections.lualine_a/c/z` | Mode icon, basename with default file-status markers, and line:column. |
| Empty `sections.lualine_b/x/y` | Keep the selected minimal layout without lualine's extra default components. |

For example, change `INSERT = ""` to another supported Nerd Font glyph and
restart Neovim. To show icon plus text, change the formatter's return expression
to `return (mode_icons[name] or "") .. " " .. name`. To use a separate bar under
each split, change `globalstatus` to `false` and restart. Comment each changed
setting's purpose and keep README.md and docs/features.md current.

## Disable or remove

Remove `{ import = "plugins.statusline" }` from `lua/config/lazy.lua` and restart
Neovim. This stops lualine and its `showmode` override; Neovim's native statusline
and mode-message defaults return. The specification and checkout can remain
unused on disk. Update README.md and docs/features.md with the changed selection;
preserve `.backups/`, the Git index/history, and old plugin installations.
