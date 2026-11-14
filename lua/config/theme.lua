-- A selected-theme menu, with the last successful selection saved for next time.
-- Usage and the separate terminal font controls: docs/appearance.md.
local M = {}

-- Keep the menu limited to the themes explicitly selected by the user.
local themes = { "default", "everforest", "ayu", "ayu-dark", "ayu-light", "ayu-mirage", "vague" }
-- Label each colorscheme clearly; plain Ayu follows Neovim's background preference.
local labels = {
  default = "Default (Neovim)",
  everforest = "Everforest",
  ayu = "Ayu (follow background)",
  ["ayu-dark"] = "Ayu Dark",
  ["ayu-light"] = "Ayu Light",
  ["ayu-mirage"] = "Ayu Mirage",
  vague = "Vague",
}
-- Store personal selection in editor state, separate from configuration and backups.
local state_file = vim.fn.stdpath("state") .. "/selected-theme.txt"
-- Everforest, Ayu, and Vague set embedded-terminal colors. Remember the original
-- palette so returning to Default restores new terminal buffers as well as editor text.
local terminal_colors = {}
-- Ayu also supplies background/foreground globals; restore those alongside ANSI colors.
local terminal_color_names = { "background", "foreground" }
for index = 0, 15 do
  terminal_color_names[#terminal_color_names + 1] = tostring(index)
end
for _, name in ipairs(terminal_color_names) do
  terminal_colors[name] = vim.g["terminal_color_" .. name]
end

function M.apply(name, save)
  -- Validate both commands and saved state; never execute file contents as code.
  if not vim.tbl_contains(themes, name) then
    vim.notify("Unknown theme: " .. tostring(name) .. ". Choose " .. table.concat(themes, ", ") .. ".",
      vim.log.levels.ERROR)
    return false
  end
  -- Applying a colorscheme also lets lazy.nvim load the selected plugin on demand.
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify("Could not load theme " .. name .. ": " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  if save then
    -- Persist only successfully applied choices; a write failure leaves this session usable.
    local saved, save_err = pcall(function()
      vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
      if vim.fn.writefile({ name }, state_file) ~= 0 then
        error("Could not write " .. state_file)
      end
    end)
    if not saved then
      vim.notify("Theme applied, but not saved: " .. tostring(save_err), vim.log.levels.WARN)
    end
  end
  return true
end

function M.select()
  -- Use Neovim's built-in selection UI; choosing a theme needs no picker dependency.
  vim.ui.select(themes, {
    -- Name the menu and distinguish the built-in theme and each plugin variant.
    prompt = "Theme:",
    format_item = function(name)
      return labels[name]
    end,
  }, function(name)
    -- Cancelling the menu leaves the current theme and saved choice unchanged.
    if name then
      M.apply(name, true)
    end
  end)
end

function M.setup()
  -- Native :colorscheme default should restore the terminal palette too.
  vim.api.nvim_create_autocmd("ColorScheme", {
    -- Own this callback so re-running setup cannot install duplicate handlers.
    group = vim.api.nvim_create_augroup("SelectedTheme", { clear = true }),
    -- Theme plugins supply their own palettes; restore the original only for Default.
    pattern = "default",
    callback = function()
      for _, name in ipairs(terminal_color_names) do
        vim.g["terminal_color_" .. name] = terminal_colors[name]
      end
    end,
    -- Explain this automatic behavior in Neovim's autocommand listing.
    desc = "Restore the original embedded-terminal palette with Default",
  })
  -- With no valid saved selection, retain Neovim's built-in default colorscheme.
  local name = "default"
  if vim.fn.filereadable(state_file) == 1 then
    local ok, lines = pcall(vim.fn.readfile, state_file, "", 1)
    if ok and vim.tbl_contains(themes, lines[1]) then
      name = lines[1]
    end
  end
  -- A missing/unavailable theme must not prevent startup; fall back to default.
  if not M.apply(name, false) then
    M.apply("default", false)
  end

  -- :Theme opens the menu; an argument applies and remembers that choice directly.
  vim.api.nvim_create_user_command("Theme", function(command)
    if command.args == "" then
      M.select()
    else
      M.apply(command.args, true)
    end
  end, {
    -- Accept zero or one theme name and offer only supported-name completions.
    nargs = "?",
    complete = function(lead)
      return vim.tbl_filter(function(theme)
        return theme:sub(1, #lead) == lead
      end, themes)
    end,
    -- Explain the command in Neovim's command listing.
    desc = "Choose and remember the editor colorscheme",
  })
end

return M
