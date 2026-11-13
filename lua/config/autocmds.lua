-- Automatic editor actions belong here; usage and removal: docs/command-line.md.
vim.api.nvim_create_autocmd("CmdlineLeave", {
  -- Own this action so reloading the configuration does not duplicate callbacks.
  group = vim.api.nvim_create_augroup("ClearQuitCommand", { clear = true }),
  -- Only inspect Ex commands; leave search prompts and other command-line types alone.
  pattern = ":",
  callback = function()
    -- Clear only submitted :q / :quit commands (including abbreviations and !).
    local command = vim.fn.getcmdline():match("^%s*([a-z]+)!?%s*$")
    if vim.v.event.abort or not vim.tbl_contains({ "q", "qu", "qui", "quit" }, command) then
      return
    end
    local window = vim.api.nvim_get_current_win()
    local previous_error = vim.v.errmsg
    -- CmdlineLeave runs before execution; wait until the command has closed its window.
    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(window)
        and vim.fn.getcmdtype() == ""
        and vim.v.errmsg == previous_error then
        -- Empty output clears the retained :q text; redraw alone leaves it visible.
        vim.cmd('echo ""')
      end
    end)
  end,
  desc = "Clear executed quit text after its window closes successfully",
})
