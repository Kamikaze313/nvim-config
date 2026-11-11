-- General keyboard shortcuts belong here; plugin shortcuts belong with the plugin.
-- Normal mode: choose Default or Everforest and remember the choice across restarts.
-- Defer requiring the theme module until use; setup runs after lazy.nvim in init.lua.
vim.keymap.set("n", "<leader>uc", function()
  require("config.theme").select()
end, { desc = "Choose colorscheme" })
