# Appearance: themes in Neovim, fonts in Kitty

Neovim's colorscheme controls code, editor backgrounds, and plugin highlights.
When Neovim runs in a terminal, the terminal controls the font family, size,
ligatures, and font rendering. A colorscheme does not install or select a font.
Everforest, Ayu, Vague, and Embark work with the current font or any other monospaced font you choose.

This environment identifies Kitty. Its configuration is
`~/.config/kitty/kitty.conf`, separate from this Neovim repository. Kitty also
has its own terminal color theme; selecting Everforest, Ayu, Vague, or Embark here changes Neovim's
colors rather than the shell's palette. Neovim GUI clients can instead support
`guifont`, but that setting does not change the font of terminal Neovim.

## Switch themes

In normal mode, press **Space u c** or run **:Theme**. Neovim's built-in menu
offers **1: Default (Neovim)**, **2: Everforest**, **3: Ayu (follow background)**,
**4: Ayu Dark**, **5: Ayu Light**, **6: Ayu Mirage**, **7: Vague**, and **8: Embark**. Enter a number
and press **Enter** to apply it; **Esc** cancels without changing anything. The menu
closes when you select or cancel. Which-key labels Space u as **Appearance**.

For example, open `init.lua`, press **Space u c**, enter **6**, and press **Enter**
to try Ayu Mirage's softer dark palette. Run `:Theme ayu-light` to compare the
light palette, or `:Theme default` to return to Default. Each selection remembers
your choice for future sessions; **Esc** closes the menu when only browsing.
The initial choice is Default, the built-in Neovim palette you already had.

To try Vague, open `init.lua`, run **:Theme vague**, or choose **7** in the menu.
Its muted dark palette applies immediately and is remembered for the next startup.
Use **:Theme default** to switch back; the menu closes after selection or **Esc**.

To try Embark, open `init.lua`, run **:Theme embark**, or press **Space u c**,
enter **8**, and press **Enter**. Its deep purple background and bright accents
apply immediately; the selection is remembered for the next startup.
Use **:Theme vague** to return to Vague or **:Theme default** for Default.
The menu closes after selection; **Esc** cancels when only browsing.

| Mode / command | Effect |
| --- | --- |
| Normal: `Space u c` | Open the selected-theme menu; description: `Choose colorscheme`. |
| `:Theme` | Open the same menu. |
| `:Theme default` | Apply and remember Neovim's Default colorscheme. |
| `:Theme everforest` | Apply and remember Everforest. |
| `:Theme ayu` | Apply and remember Ayu, following the current `background` preference (dark or light). |
| `:Theme ayu-dark` | Apply and remember Ayu Dark, explicitly setting a dark background. |
| `:Theme ayu-light` | Apply and remember Ayu Light, explicitly setting a light background. |
| `:Theme ayu-mirage` | Apply and remember Ayu Mirage, explicitly setting a dark background. |
| `:Theme vague` | Apply and remember Vague's muted dark palette. |
| `:Theme embark` | Apply and remember Embark's deep purple dark palette. |
| `:colorscheme {name}` | Native command with any supported name above: apply for this session without changing the remembered choice. |
| `:help everforest.nvim.txt` | Open upstream theme help; load Everforest first if necessary. Close with `:q`. |
| `:help 'background'` | Explain the dark/light preference followed by plain Ayu and Everforest; close with `:q`. |

The choice is a plain theme name in `stdpath("state")/selected-theme.txt`
(normally `~/.local/state/nvim/selected-theme.txt`). Only successful choices
made through `:Theme` or Space u c are saved. Missing or invalid state selects
Default. If the chosen theme cannot load, startup reports it and falls back
to Default. If saving fails, the change still applies to the current session
and a warning explains that it was not saved. With multiple Neovim instances,
the last saved selection is used by the next instance; existing instances do
not automatically change together.

Everforest, Ayu, Vague, and Embark also set the palette for Neovim's embedded terminals. A `ColorScheme`
callback restores the original palette when Default is applied, including via
`:colorscheme default`. This affects newly opened terminal buffers; existing
terminal buffers keep the palette they received on creation. Kitty's outer
terminal palette is independent of these embedded-terminal settings.

Plain `ayu` follows `:set background=dark` or `:set background=light`; its
upstream `mirage = false` default chooses Dark for a dark background. Use an
explicit variant to keep that palette on restart. Selecting an explicit variant
also sets `background`, so switching afterward to plain Ayu or Everforest follows
that preference. Default uses the current preference too.
Within a session, plain Ayu also retains its last Dark/Mirage preference;
`:Theme ayu-dark` resets it to Dark, while `:Theme ayu-mirage` selects Mirage.
Embark has a fixed dark palette and sets `background=dark` when applied.
Switching afterward to plain Ayu, Everforest, or Default follows that dark preference.

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

Default is built in. **neanias/everforest-nvim**,
[**Shatur/neovim-ayu**](https://github.com/Shatur/neovim-ayu),
[**vague-theme/vague.nvim**](https://github.com/vague-theme/vague.nvim), and
[**embark-theme/vim**](https://github.com/embark-theme/vim) are the selected
theme plugins; none requires additional plugins, an icon pack, or a special
font. Ayu requires Neovim 0.8+; Neovim 0.12.0-dev with LuaJIT and Git are already
available on this device. Kitty supports
the RGB colors explicitly enabled by `termguicolors`, which Embark requires.
Git is already used by lazy.nvim to install and update plugins.
The theme menu uses native `vim.ui.select`
and does not depend on Telescope or Snacks. The font chooser is part of Kitty.

| Location / setting | Value / reason |
| --- | --- |
| `lua/plugins/everforest.lua` | Everforest specification; default upstream palette/styles via `opts = {}`. |
| Everforest `version` / `main` | `false` / `"everforest"`: follow upstream's recommended main branch and identify its setup module; the lockfile pins the commit. |
| `lua/plugins/ayu.lua` | Ayu specification; `opts = {}` keeps upstream styles, `mirage = false`, `terminal = true`, and empty highlight overrides. Explicit variants select their own palettes. |
| Ayu `version` / `main` | `false` / `"ayu"`: follow the upstream default branch and identify the setup module because its name differs from the repository; the lockfile pins the commit. |
| `lua/plugins/vague.lua` | Vague specification; `opts = {}` keeps upstream colors, an opaque background (`transparent = false`), bold/italic styles, and embedded-terminal ANSI colors. |
| Vague `version` / `main` | `false` / `"vague"`: follow the upstream default branch and identify its setup module; the lockfile pins the commit. |
| `lua/plugins/embark.lua` | Official Embark Vim/Neovim specification; upstream palette/styles with no overrides or Lua setup callback. |
| Embark `name` / `version` | `"embark"` / `false`: use upstream's recommended plugin name instead of the generic repository name `vim`, and follow its default `main` branch; the lockfile pins the commit. |
| All four plugins' `lazy` | `true`: load when one of their colorschemes is requested; a Default startup leaves theme plugins unloaded. |
| `lua/config/options.lua`: `termguicolors` | `true`: use RGB theme colors on the supported terminal. |
| `lua/config/theme.lua`: `themes` | `default`, `everforest`, `ayu`, `ayu-dark`, `ayu-light`, `ayu-mirage`, `vague`, and `embark`, for the menu, validation, and completion. |
| Theme `labels` | Readable names for the selected themes and Ayu variants, including background-following Ayu, Vague, and Embark. |
| Theme `state_file` | Neovim's state directory; store the choice separately from versioned configuration. |
| `terminal_colors`, `terminal_color_names`, and the `SelectedTheme` autocommand group | Remember the original ANSI colors plus background/foreground globals and restore them on `ColorScheme default`; clearing the group avoids duplicate callbacks. |
| Theme menu `prompt`, `format_item` | Label the menu and distinguish built-in Default, Everforest, each Ayu choice, Vague, and Embark. |
| `:Theme` `nargs`, `complete`, `desc` | Optional theme argument, supported-name completion, and an explanatory command description. |
| `lua/config/keymaps.lua` | Normal-mode Space u c mapping, with its `desc`. |
| `lua/plugins/which-key.lua` | Normal-mode Appearance group at Space u. |
| `lua/config/lazy.lua` / `init.lua` | Import all four theme specifications and restore the selection after the manager can load them on demand. |

The plugin checkouts are `~/.local/share/nvim/lazy-selected/everforest-nvim`
and `~/.local/share/nvim/lazy-selected/neovim-ayu`; Vague lives in
`~/.local/share/nvim/lazy-selected/vague.nvim`. Ayu and Vague are installed explicitly
through `:Lazy install neovim-ayu` and `:Lazy install vague.nvim`; on a new device, run
`:Lazy install` to install all selected plugins, then restart. No extra download
is needed for each Ayu variant. Installation and updates use Git; no compiler,
language server, or additional theme plugin is required by Ayu or Vague.
Embark lives in `~/.local/share/nvim/lazy-selected/embark` and installs with
`:Lazy install embark`. It needs Neovim, Git for installation, and a true-color
terminal with `termguicolors` enabled; those dependencies are already available.
It needs no compiler, parser, native binary, or helper plugin.
Embark uses an opaque `#1e1c31` background and `#cbe3e7` foreground by default,
with terminal italics disabled (`g:embark_terminal_italics = 0`). It has no
separate light variant. Its configuration is Vimscript globals rather than Lua
`opts`; any later customization belongs in a commented `init` callback in
`lua/plugins/embark.lua`, so globals are set before the colorscheme loads.
Vague uses a fixed dark palette with an opaque `#141415` background and
`#cdcdcd` foreground by default. It has no separate light variant and requires
no parser, compiler, or native binary. To customize it, edit `opts` in
`lua/plugins/vague.lua`, commenting each added setting's purpose, then restart.
Its upstream README documents `transparent`, `bold`, `italic`, `colors`, and
`on_highlights` options; `opts = {}` deliberately adds no overrides.
Everforest uses its medium-contrast palette and opaque background by default,
with italic comments. It follows Neovim's `background` setting for light/dark
mode; this configuration does not force a different background preference.
Kitty's font and color settings remain outside this repository. Existing installations
and `.backups/` are preserved.

Validation: startup, loading on demand, distinct Dark/Light/Mirage palettes,
saved-choice restoration for all four Ayu names, command completion, menu labels,
selection/cancellation callbacks, the shortcut, and switching back to Everforest
and Default passed using isolated state/cache directories. Default also restored
the original embedded-terminal palette, including Ayu's background/foreground
globals. Earlier checks covered invalid-state fallback, the interactive native
menu, and Kitty's installed chooser; no personal theme or font selection was
changed during validation.

Vague validation passed for startup, loading on demand, its default foreground,
background and terminal ANSI palette, command completion, saving and restoring
the choice in a new session, switching from Ayu Light and back to Everforest/Default,
and restoring the original terminal colors with Default. Checks used isolated
state/cache directories; the personal Ayu Mirage selection stayed unchanged.
lazy.nvim generated Vague's installed commit into `lazy-lock.json`; existing
plugin versions did not change.

Embark validation passed for startup, loading on demand, its default RGB colors,
command completion, saving and restoring the choice in a new session, and
switching from Ayu Light and back to Vague/Default. Default restored the original
embedded-terminal red. Checks used isolated state/cache directories; the personal
Vague selection stayed unchanged. lazy.nvim recorded Embark's installed commit
in `lazy-lock.json`; existing plugin versions did not change.

## Disable or remove

To disable only Embark, first run `:Theme vague` (or another remaining choice)
to save a replacement. Remove the `plugins.embark` import from `lua/config/lazy.lua`
and the `embark` entries from `themes` and `labels` in `lua/config/theme.lua`.
Restart Neovim. The specification and checkout can remain unused on disk.
For a temporary switch, `:colorscheme default` affects only the current session.

To disable only Vague, first run `:Theme default` (or another remaining choice)
to save a replacement. Remove the `plugins.vague` import from `lua/config/lazy.lua`
and the `vague` entries from `themes` and `labels` in `lua/config/theme.lua`.
Restart Neovim. The specification and checkout can remain unused on disk.
For a temporary switch, `:colorscheme default` affects only the current session.

To disable only Ayu, first run `:Theme default` or `:Theme everforest` to save
a remaining choice. Remove the `plugins.ayu` import from `lua/config/lazy.lua`
and the four `ayu*` entries from `themes` and `labels` in `lua/config/theme.lua`.
Restart Neovim. The specification and checkout can remain unused on disk.

To use only Default, run `:Theme default` before removing `plugins.everforest`,
`plugins.ayu`, `plugins.vague`, and `plugins.embark` imports. Remove their supported choices and
labels too. To remove the theme feature entirely, also remove `require("config.theme").setup()` from
`init.lua`, the Space u c keymap, and the Appearance group in which-key. Restart
Neovim. The saved selection and specifications can remain unused on disk.
Optionally use `:Lazy clean` for unused checkouts in `lazy-selected`.

RGB colors can remain enabled independently. Removing that option returns
to Neovim's automatic terminal detection. Update README.md and docs/features.md
with configuration changes. To change fonts back, use Kitty's chooser again;
disabling a Neovim theme does not change the terminal font.
