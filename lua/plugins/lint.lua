-- Flake8 diagnostics through the focused nvim-lint adapter; docs/python.md has usage.
return {
  {
    "mfussenegger/nvim-lint",
    -- Follow the upstream default branch; pin the installed commit in lazy-lock.json.
    version = false,
    -- Load only for Python or an explicit manual lint request.
    ft = "python",
    cmd = "Flake8",
    config = function()
      local lint = require("lint")
      local python = require("config.python")
      -- Enable only the user-selected Python linter.
      lint.linters_by_ft = { python = { "flake8" } }
      local flake8 = lint.linters.flake8
      -- Re-evaluate the executable per run so different project environments work.
      flake8.cmd = function() return python.executable("flake8", python.root(0)) end
      local parse = flake8.parser
      flake8.parser = function(output, bufnr, cwd)
        local diagnostics = parse(output, bufnr, cwd)
        for _, diagnostic in ipairs(diagnostics) do
          -- Highlight syntax errors and undefined/unbound names as errors; keep the
          -- adapter's warning severity for style findings and unused imports.
          if vim.tbl_contains({ "E999", "F821", "F822", "F823" }, diagnostic.code) then
            diagnostic.severity = vim.diagnostic.severity.ERROR
          end
        end
        return diagnostics
      end

      local function run()
        -- Scratch, terminal, and non-Python buffers have no Flake8 work to run.
        if vim.bo.filetype ~= "python" or vim.bo.buftype ~= "" then return end
        if python.executable("flake8", python.root(0)) == "" then
          vim.notify("Flake8 was not found. Install it in the active environment or on PATH.", vim.log.levels.WARN)
          return
        end
        local file = vim.api.nvim_buf_get_name(0)
        -- Start in the source directory so Flake8 discovers the nearest .flake8,
        -- setup.cfg, or tox.ini. The adapter sends current buffer text through stdin.
        lint.try_lint("flake8", { cwd = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd() })
      end

      vim.api.nvim_create_user_command("Flake8", run, {
        desc = "Run Flake8 on the current Python buffer",
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        -- Use one named group to keep automatic linting easy to identify and remove.
        group = vim.api.nvim_create_augroup("SelectedPythonLint", { clear = true }),
        desc = "Lint Python when entering or saving a buffer",
        callback = function(event)
          -- Run in the event's buffer even if another window has focus.
          vim.api.nvim_buf_call(event.buf, run)
        end,
      })
    end,
    keys = {
      -- Normal mode; the command is a no-op outside ordinary Python buffers.
      { "<leader>cl", "<cmd>Flake8<cr>", mode = "n", desc = "Lint Python with Flake8" },
    },
  },
}
