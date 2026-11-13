-- Ayu and its Dark, Light, and Mirage variants, selected through the theme menu.
-- Commands, dependencies, usage, and removal: docs/appearance.md.
return {
  {
    "Shatur/neovim-ayu",
    -- Follow the upstream default branch; the lockfile pins the installed commit.
    version = false,
    -- The repository name differs from its setup module; identify it explicitly.
    main = "ayu",
    -- lazy.nvim loads Ayu only when one of its colorschemes is requested.
    lazy = true,
    -- Keep upstream palette/style defaults, including embedded-terminal colors.
    opts = {},
  },
}
