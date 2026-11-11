-- Everforest: the selected alternative to Neovim's built-in default colorscheme.
-- Theme switching, font guidance, dependencies, and removal: docs/appearance.md.
return {
  {
    "neanias/everforest-nvim",
    -- Upstream has no release tags and recommends main; the lockfile records the commit.
    version = false,
    -- The repository name differs from its Lua module; tell lazy.nvim what to set up.
    main = "everforest",
    -- lazy.nvim loads the plugin when :colorscheme everforest is requested.
    -- Keep it unloaded while the built-in default theme is selected.
    lazy = true,
    -- Use Everforest's own palette and style defaults without extra integrations.
    opts = {},
  },
}
