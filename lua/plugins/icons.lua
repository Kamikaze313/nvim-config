-- mini.icons: file, extension, and folder glyphs for Snacks Explorer.
-- Usage, custom mappings, font requirements, and removal: docs/icons.md.
return {
  {
    -- Use only the standalone icon provider, without the rest of mini.nvim.
    "nvim-mini/mini.icons",
    -- Follow stable releases on manual updates; lazy-lock.json records the commit.
    version = "*",
    -- Snacks declares this dependency, so it loads before Explorer is configured.
    lazy = true,
    -- Tell lazy.nvim which setup module owns these options.
    main = "mini.icons",
    opts = {
      -- Use Nerd Font symbols; Kitty already has a compatible font configured.
      style = "glyph",
    },
  },
}
