-- grug-far: visual find/replace with an editable form and live change preview.
-- Controls, scope, disk-write behavior, and customization: docs/replace.md.
local function open_replace(project)
  local path = vim.api.nvim_buf_get_name(0)
  -- Current-file replacement works on saved files, not scratch/directory buffers.
  -- Refuse an empty scope so this shortcut cannot accidentally search the project.
  if not project and (vim.bo.buftype ~= "" or vim.fn.filereadable(path) ~= 1) then
    vim.notify("Open and save a file before using current-file replacement.", vim.log.levels.WARN)
    return
  end
  -- Ripgrep reads disk; require saving current-file edits so the preview matches them.
  if not project and vim.bo.modified then
    vim.notify("Save this file with :write before opening find/replace.", vim.log.levels.WARN)
    return
  end
  -- Project scope follows Explorer: nearest Git root, otherwise the current directory.
  if project then
    path = vim.fs.root(0, ".git") or vim.fn.getcwd()
  end
  require("grug-far").open({
    prefills = {
      -- Paths uses backslash-space separators, not Ex-command escaping: leave
      -- characters such as # literal so filenames retain their actual spelling.
      paths = path:gsub(" ", "\\ "),
    },
  })
end

return {
  {
    "MagicDuck/grug-far.nvim",
    -- Follow stable releases on manual updates; lazy-lock.json records the commit.
    version = "*",
    -- Load only when opening the panel, including the upstream range-aware command.
    cmd = { "GrugFar", "GrugFarWithin" },
    -- Identify the setup module explicitly for lazy.nvim's opts handling.
    main = "grug-far",
    opts = {
      -- Use the installed ripgrep backend; no ast-grep installation is needed.
      enabledEngines = { "ripgrep" },
      -- Place the form on the right so the original file remains visible beside it.
      windowCreationCommand = "botright vsplit",
      -- Allow replacing single characters as well as words and longer strings.
      minSearchChars = 1,
      prefills = {
        -- Treat punctuation literally by default; remove this flag in the UI for regex.
        flags = "--fixed-strings",
      },
      keymaps = {
        -- Normal mode inside the form only. Upstream assigns descriptive desc fields
        -- and shows these keys in its help header; other actions keep upstream keys.
        replace = { n = "<leader>r" }, -- Space r applies the previewed replacement.
        close = { n = "q" }, -- Close the form and its split without applying pending edits.
      },
    },
    keys = {
      {
        "<leader>sr",
        function() open_replace(false) end,
        -- Current-file scope is the default entry point for ordinary substitutions.
        mode = "n",
        desc = "Find and replace in current file",
      },
      {
        "<leader>sR",
        function() open_replace(true) end,
        -- Uppercase R explicitly chooses the wider project scope.
        mode = "n",
        desc = "Find and replace in project",
      },
    },
  },
}
