-- Embark's deep purple palette, selected through the existing theme menu.
-- Commands, dependencies, usage, and removal: docs/appearance.md.
return {
  {
    "embark-theme/vim",
    -- Use upstream's recommended name instead of the generic repository name, vim.
    name = "embark",
    -- Follow the upstream default branch; the lockfile pins the installed commit.
    version = false,
    -- Load only when :colorscheme embark is requested, including saved selections.
    lazy = true,
    -- Keep upstream palette/style defaults; this Vimscript theme needs no Lua setup.
  },
}
