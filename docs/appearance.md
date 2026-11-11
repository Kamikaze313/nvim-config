# Appearance: themes in Neovim, fonts in Kitty

Neovim's colorscheme controls code, editor backgrounds, and plugin highlights.
When Neovim runs in a terminal, the terminal controls the font family, size,
ligatures, and font rendering. A colorscheme does not install or select a font.
Everforest works with the current font or any other monospaced font you choose.

This environment identifies Kitty. Its configuration is
`~/.config/kitty/kitty.conf`, separate from this Neovim repository. Kitty also
has its own terminal color theme; selecting Everforest here changes Neovim's
colors rather than the shell's palette. Neovim GUI clients can instead support
`guifont`, but that setting does not change the font of terminal Neovim.

## Switch themes

In normal mode, press **Space u c** or run **:Theme**. Neovim's built-in menu
offers **1: Default (Neovim)** and **2: Everforest**. Enter a number and press
**Enter** to apply it; **Esc** cancels without changing anything. The menu
closes when you select or cancel. Which-key labels Space u as **Appearance**.

For example, open a C file, run `:Theme everforest`, and compare its colors
with `:Theme default`. Both commands remember your choice for future sessions.
The initial choice is Default, the built-in Neovim palette you already had.

| Mode / command | Effect |
| --- | --- |
| Normal: `Space u c` | Open the two-choice theme menu; description: `Choose colorscheme`. |
| `:Theme` | Open the same menu. |
| `:Theme default` | Apply and remember Neovim's Default colorscheme. |
| `:Theme everforest` | Apply and remember Everforest. |
| `:colorscheme default` / `:colorscheme everforest` | Native commands: apply for this session without changing the remembered choice. |
| `:help everforest.nvim.txt` | Open upstream theme help; load Everforest first if necessary. Close with `:q`. |

The choice is a plain theme name in `stdpath("state")/selected-theme.txt`
(normally `~/.local/state/nvim/selected-theme.txt`). Only successful choices
made through `:Theme` or Space u c are saved. Missing or invalid state selects
Default. If the chosen theme cannot load, startup reports it and falls back
to Default. If saving fails, the change still applies to the current session
and a warning explains that it was not saved. With multiple Neovim instances,
the last saved selection is used by the next instance; existing instances do
not automatically change together.

Everforest also sets the palette for Neovim's embedded terminals. A `ColorScheme`
callback restores the original palette when Default is applied, including via
`:colorscheme default`. This affects newly opened terminal buffers; existing
terminal buffers keep the palette they received on creation. Kitty's outer
terminal palette is independent of these embedded-terminal settings.

## Choose fonts in Kitty

Kitty **0.48.2** and its built-in chooser are already installed. Run this in a
normal Kitty shell, outside Neovim's `:terminal` so Kitty can render its preview:

```sh
kitten choose-fonts
```

Type part of a font's name to filter the list, then press **Enter** to select
a family and preview its regular, bold, and italic faces. Press **R** to fine-tune
the regular face; the other styles adjust with it. Use the chooser's on-screen
controls to apply or cancel. Apply/save
writes Kitty's font configuration and, by default, reloads the parent Kitty
instance. This affects Neovim and other apps in that Kitty instance. Follow the
chooser's on-screen exit control to close it without saving when only comparing.
Use `kitten choose-fonts --help` for its supported options.

For example, preview **JetBrainsMono Nerd Font Mono**, then apply it if you
prefer it. **MonoLisa Nerd Font Mono** is also installed and is your currently
configured family, at **19 pt**. You can use the chooser again to return to it.
No font download or new Neovim plugin is needed to switch between these installed
families. To use a font not installed on the machine, install that font first.

The existing Kitty configuration requests **Maple Mono NF Italic** for italics,
but font matching here falls back to Noto Sans Mono. If you want consistent
italics, select the italic face belonging to the chosen family in Kitty, or
set `italic_font auto` in Kitty's config. This task leaves the terminal's
existing font settings unchanged so you can preview and choose the family.

Kitty's usual size controls are **Ctrl-Shift-+** to enlarge,
**Ctrl-Shift--** to shrink, and **Ctrl-Shift-Backspace** to reset. A font-size
change affects the terminal, independently of the selected Neovim theme.

## Dependencies and settings

Default is built in. **neanias/everforest-nvim** is the one added plugin; it
requires no additional plugins, icon pack, or special font. Kitty supports
the RGB colors explicitly enabled by `termguicolors`. Git is already used by
lazy.nvim to install and update plugins. The theme menu uses native `vim.ui.select`
and does not depend on Telescope or Snacks. The font chooser is part of Kitty.

| Location / setting | Value / reason |
| --- | --- |
| `lua/plugins/everforest.lua` | Everforest specification; default upstream palette/styles via `opts = {}`. |
| Plugin `version` | `false`: upstream has no release tags and recommends main; the lockfile records the exact installed commit. |
| Plugin `main` | `"everforest"`: identify the Lua setup module because its name differs from the repository. |
| Plugin `lazy` | `true`: load when its colorscheme is requested, keeping it unloaded with Default. |
| `lua/config/options.lua`: `termguicolors` | `true`: use RGB theme colors on the supported terminal. |
| `lua/config/theme.lua`: `themes` | Only `default` and `everforest`, for the menu, validation, and completion. |
| Theme `state_file` | Neovim's state directory; store the choice separately from versioned configuration. |
| `terminal_colors` and the `SelectedTheme` autocommand group | Remember the original terminal palette and restore it on `ColorScheme default`; clearing the group avoids duplicate callbacks. |
| Theme menu `prompt`, `format_item` | Label the menu and distinguish built-in Default from Everforest. |
| `:Theme` `nargs`, `complete`, `desc` | Optional theme argument, supported-name completion, and an explanatory command description. |
| `lua/config/keymaps.lua` | Normal-mode Space u c mapping, with its `desc`. |
| `lua/plugins/which-key.lua` | Normal-mode Appearance group at Space u. |
| `init.lua` | Restore the selection after the manager can load Everforest on demand. |

The plugin checkout is `~/.local/share/nvim/lazy-selected/everforest-nvim`.
Everforest uses its medium-contrast palette and opaque background by default,
with italic comments. It follows Neovim's `background` setting for light/dark
mode; this configuration does not force a different background preference.
No formatter, language server, or other theme is installed with it. Kitty's
font and color settings remain outside this repository. Existing installations
and `.backups/` are preserved.

Validation: startup, both palettes, saved-choice restoration, invalid-state
fallback, and restoration of the embedded-terminal palette passed using isolated
state/cache directories. The normal-mode menu and cancellation were also checked
interactively. Kitty's installed chooser and its options were verified; no font
selection was saved during these checks.

## Disable or remove

To use only Default, run `:Theme default` before removing the
`plugins.everforest` import from `lua/config/lazy.lua`. Also remove `everforest`
from the supported choices and update the menu labels/docs, or remove the theme
feature entirely: remove `require("config.theme").setup()` from `init.lua`,
the Space u c keymap, the Appearance group in which-key, and the Everforest
import. Restart Neovim. The saved selection and specification can remain unused
on disk. Optionally use `:Lazy clean` for the unused new plugin checkout.

RGB colors can remain enabled independently. Removing that option returns
to Neovim's automatic terminal detection. Update README.md and docs/features.md
with configuration changes. To change fonts back, use Kitty's chooser again;
disabling a Neovim theme does not change the terminal font.
