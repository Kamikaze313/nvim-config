-- Telescope: searchable lists of files, project text, buffers, history, and help.
-- Usage and default picker controls: docs/telescope.md.
return {
  {
    "nvim-telescope/telescope.nvim",
    -- Follow stable releases when manually updating; the lockfile records the exact commit.
    version = "*",
    -- Load only when a Telescope command or one of the shortcuts below is used.
    cmd = "Telescope",
    -- Plenary supplies the Lua utilities and asynchronous jobs Telescope requires.
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Use Telescope's default layout, matching, previews, and picker controls.
    opts = {},
    -- These normal-mode shortcuts use the Space leader from config/options.lua.
    -- Command strings keep Telescope unloaded until a shortcut is invoked.
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search project text" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find open buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
    },
  },
}
