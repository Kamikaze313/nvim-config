-- Syntax-aware Python/Lua highlighting; parsers are installed explicitly.
-- Dependencies, commands, examples, and disabling: docs/treesitter.md.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Use the current API for Neovim 0.12, rather than the frozen master branch.
    branch = "main",
    -- Follow main; lazy-lock.json records the exact installed revision.
    version = false,
    -- Upstream requires startup loading so its runtime integration is available.
    lazy = false,
    -- Refresh selected, already-installed parsers when explicitly updating the plugin.
    -- First-time parser installation remains manual: :TSInstall python lua.
    build = ":TSUpdate python lua",
    opts = {
      -- Give this rebuild its own parsers/queries, preserving old editor data.
      install_dir = vim.fn.stdpath("data") .. "/treesitter-selected",
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        -- Clearing our own group keeps configuration reloads from duplicating callbacks.
        group = vim.api.nvim_create_augroup("SelectedTreesitterHighlight", { clear = true }),
        -- Enable only the selected languages; other filetypes keep existing behavior.
        pattern = { "python", "lua" },
        desc = "Start Tree-sitter highlighting for Python and Lua",
        callback = function(event)
          -- Special buffers such as pickers are not ordinary source files.
          if vim.bo[event.buf].buftype ~= "" then return end
          -- Missing parsers on a new device must not prevent opening/editing files.
          local ok, err = pcall(vim.treesitter.start, event.buf)
          if not ok then
            vim.notify("Tree-sitter highlighting unavailable. Run :TSInstall python lua, "
              .. "then reopen the buffer.\n" .. tostring(err), vim.log.levels.WARN)
          end
        end,
      })
    end,
  },
}
