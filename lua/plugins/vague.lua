-- Vague's muted dark palette, selected through the existing theme menu.
-- Commands, dependencies, usage, and removal: docs/appearance.md.
return {
  {
    "vague-theme/vague.nvim",
    -- Follow the upstream default branch; the lockfile pins the installed commit.
    version = false,
    -- Identify the setup module explicitly because the repository has a .nvim suffix.
    main = "vague",
    -- Load only when :colorscheme vague is requested, including saved selections.
    lazy = true,
    -- Keep upstream colors, opaque background, bold/italic styles, and terminal palette.
    opts = {},
  },
}
