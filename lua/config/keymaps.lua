-- General keyboard shortcuts belong here; plugin shortcuts belong with the plugin.
-- Normal mode: choose a selected colorscheme and remember it across restarts.
-- Defer requiring the theme module until use; setup runs after lazy.nvim in init.lua.
vim.keymap.set("n", "<leader>uc", function()
  require("config.theme").select()
end, { desc = "Choose colorscheme" })

-- Load the native bottom-terminal helper only when its toggle is requested.
local function toggle_terminal()
  require("config.terminal").toggle()
end

-- Terminals can encode Ctrl-/ as Ctrl-_; support both encodings for portability.
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  -- Normal mode (including terminal normal mode): open or hide the bottom shell.
  vim.keymap.set("n", key, toggle_terminal, { desc = "Toggle bottom terminal" })
  -- Terminal input: leave input mode before hiding, so the editor receives no shell input.
  vim.keymap.set("t", key, "<C-\\><C-n><cmd>BottomTerminal<cr>", {
    desc = "Toggle bottom terminal",
  })
end

-- Terminal input: two quick Esc presses enter normal mode without hiding the pane.
-- Keep the existing timeoutlen; a single Esc still reaches terminal apps after that timeout.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Enter terminal normal mode" })

-- Offer the same toggle as an explicit command, independent of terminal key encoding.
vim.api.nvim_create_user_command("BottomTerminal", toggle_terminal, {
  desc = "Toggle the bottom terminal, keeping its shell when hidden",
})
