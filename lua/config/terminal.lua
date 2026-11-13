-- One reusable native shell, shown in a bottom split on demand.
-- Controls, dependencies, and disabling instructions: docs/terminal.md.
local M = {}

-- Remember the buffer across toggles so hiding the window preserves the shell.
local terminal_buffer

function M.toggle()
  local valid = terminal_buffer and vim.api.nvim_buf_is_valid(terminal_buffer)
  if valid then
    -- Toggle only the current tab's view; other tabs can show the same shell.
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, window in ipairs(windows) do
      if vim.api.nvim_win_get_buf(window) == terminal_buffer then
        if #windows == 1 then
          -- Neovim cannot close its final window; hide the terminal behind a new buffer.
          vim.cmd.enew()
        else
          -- Close the view without stopping its job; bufhidden=hide keeps it alive.
          vim.api.nvim_win_close(window, false)
        end
        return
      end
    end
  end

  -- Check without waiting: an exited or deleted shell should be replaced on reopening.
  local channel = valid and vim.bo[terminal_buffer].channel or 0
  local running = channel > 0 and vim.fn.jobwait({ channel }, 0)[1] == -1
  if running then
    -- Full-width bottom split, initially 12 rows, reusing the existing process/output.
    vim.cmd("botright 12split")
    vim.api.nvim_win_set_buf(0, terminal_buffer)
  else
    -- Retire a finished, hidden terminal; never delete a terminal visible in another tab.
    if valid and #vim.fn.win_findbuf(terminal_buffer) == 0 then
      vim.api.nvim_buf_delete(terminal_buffer, { force = true })
    end
    -- Native :terminal starts 'shell' in the current working directory, on demand only.
    vim.cmd("botright 12new")
    vim.cmd.terminal()
    terminal_buffer = vim.api.nvim_get_current_buf()
    -- Hiding the split must preserve running commands and the shell's working directory.
    vim.bo[terminal_buffer].bufhidden = "hide"
  end

  -- Focus shell input; Esc Esc (or native Ctrl-\ then Ctrl-n) returns to normal mode.
  vim.cmd.startinsert()
end

return M
