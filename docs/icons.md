# File and folder icons with mini.icons

The standalone **nvim-mini/mini.icons** plugin supplies Snacks Explorer with
colored symbols for filenames, extensions, file types, and folders. Default
mappings are used; no individual icon overrides are enabled yet.
The selected grug-far replacement panel also detects this provider automatically
for its result file icons; see the [replacement guide](replace.md).

## Brief usage

Restart Neovim, open this configuration's `init.lua`, and press **Space e** in
normal mode. `init.lua` and `README.md` show their Neovim-config and readme icons;
folders have directory icons. Use **j/k** to move, **Enter** or **l** to open a
file or expand a folder, and **h** to collapse a folder. An expanded folder uses
Snacks' open-folder icon. Press **Space e** again to close the tree, or **q**
while focused inside it. See the [Explorer guide](explorer.md) for all controls.

Icons appear automatically and add no commands, keymaps, or separate window.
The existing normal-mode **Space e** mapping remains `Toggle project file explorer`.
Use `:help mini-icons` for upstream documentation and `:q` to close help.
To inspect a mapping, run `:lua vim.print(MiniIcons.get('file', 'main.c'))`;
the result includes its symbol, highlight group, and whether it is a fallback.

## Dependencies and loading

- **Neovim**, lazy.nvim, and Git for plugin installation; this machine runs
  Neovim 0.12.0-dev. mini.icons has no additional plugin dependencies.
- **Nerd Fonts 3+** glyph support in the terminal, especially Material Design
  (`nf-md-*`) symbols. A patched font or Nerd Fonts Symbols fallback works.
  Kitty currently requests the installed **MonoLisa Nerd Font Mono**; the installed
  **0xProto Nerd Font Mono** also covers newer symbols through font fallback.
  If symbols appear as squares, select 0xProto Nerd Font Mono or another Nerd
  Fonts 3+ family in Kitty. On another machine, install/select a compatible font;
  see [Kitty font controls](appearance.md#choose-fonts-in-kitty).
- **Snacks Explorer** consumes these icons. Git status, diagnostics, and search
  markers retain their configured text labels. Oil's icon column and which-key's
  mapping icons remain disabled. No devicons compatibility shim is installed.

`lua/plugins/icons.lua` contains the standalone provider specification, explicitly
imported in `lua/config/lazy.lua`. `lua/plugins/explorer.lua` declares mini.icons
as a Snacks dependency and enables `picker.sources.explorer.icons.files.enabled`.
lazy.nvim initializes mini.icons before Snacks during startup; the tree still
opens only on request. This installs neither the full mini.nvim library nor a
second icon provider. The checkout is
`~/.local/share/nvim/lazy-selected/mini.icons`; the exact installed commit is
generated into `lazy-lock.json` (initial installation: **v0.18.0**).
Updates remain manual through lazy.nvim.

Validation: startup and provider loading passed. Checks covered C source/header,
Lua configuration, readme, Makefile, and unknown-extension mappings, colored
file/open-folder formatting, and opening/closing the Explorer sidebar.

| Setting | Value | Purpose |
| --- | --- | --- |
| `version` | `"*"` | Use stable releases on manual updates and record the installed commit. |
| `lazy` | `true` | Load through Snacks' dependency, rather than independently at startup. |
| `main` | `"mini.icons"` | Let lazy.nvim call the correct setup module with `opts`. |
| `opts.style` | `"glyph"` | Display symbols using the terminal's Nerd Font support. |
| Snacks `dependencies` | `"nvim-mini/mini.icons"` | Configure the provider before Snacks needs it. |
| Explorer `icons.files.enabled` | `true` | Display file and folder icons in the tree. |

## Customize symbols and colors

Edit `opts` in `lua/plugins/icons.lua`. Defaults already cover common languages;
add only the overrides you want. For example, replacing its current `opts` with
this table gives `.c` files a blue C icon, `Makefile` a yellow gear, and folders
named `src` a blue folder icon:

```lua
opts = {
  -- Render the supplied Nerd Font characters instead of ASCII initials.
  style = "glyph",
  -- Match lowercase file extensions without a leading dot.
  extension = {
    c = { glyph = "", hl = "MiniIconsBlue" }, -- Identify C source files.
  },
  -- Exact filenames take precedence over extension/filetype lookup.
  file = {
    Makefile = { glyph = "", hl = "MiniIconsYellow" }, -- Highlight build files.
  },
  -- Customize folders by name; Snacks supplies the expanded-folder glyph.
  directory = {
    src = { glyph = "", hl = "MiniIconsBlue" }, -- Mark source folders.
  },
},
```

Restart Neovim after editing and reopen the tree with **Space e**. Unlisted
files retain their defaults. `glyph` selects the character; `hl` names a Neovim
highlight group. Either field can be omitted to retain the resolved default.
Available built-in colors include `MiniIconsAzure`, `MiniIconsBlue`,
`MiniIconsCyan`, `MiniIconsGreen`, `MiniIconsGrey`, `MiniIconsOrange`,
`MiniIconsPurple`, `MiniIconsRed`, and `MiniIconsYellow`. Their appearance follows
the current colorscheme. See `:help MiniIcons.config` for other categories.

Choose characters from the [Nerd Fonts cheat sheet](https://www.nerdfonts.com/cheat-sheet)
or another font your terminal supports. Snacks renders text glyphs; arbitrary
VS Code SVG/PNG icon themes cannot be installed as an icon pack. Changing the
terminal's font does not change which icon mini.icons assigns to an extension.
Changing `MiniIcons.config` interactively does not refresh its cached mappings;
edit `opts` and restart, or explicitly call `MiniIcons.setup()` with the new options.

For open-folder symbols, change `icons.files.dir_open` beside `enabled` in
`lua/plugins/explorer.lua`; `dir` and `file` there are fallback symbols, rather
than the per-extension mappings supplied by mini.icons.

## Disable or remove

To hide Explorer's icons, change its `icons.files.enabled` to `false` in
`lua/plugins/explorer.lua`, update its inline comment, and restart Neovim.
The provider stays installed but the tree shows names without icons.

To stop loading the provider as well, remove Snacks' `dependencies` entry for
`nvim-mini/mini.icons` and remove `{ import = "plugins.icons" }` from
`lua/config/lazy.lua`. Do both, and disable Explorer's icons as above, then restart.
The specification and download may remain on disk. Update README.md and
docs/features.md when changing the selection; preserve `.backups/` and the old
plugin installations outside `lazy-selected`.
