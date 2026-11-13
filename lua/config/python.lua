-- Shared Python environment lookup and native diagnostics/LSP activation.
-- Dependencies, controls, project settings, and removal: docs/python.md.
local M = {}

-- Find the nearest Python project or Git root, including standalone Flake8 projects.
M.root_markers = {
  "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg",
  "tox.ini", ".flake8", "requirements.txt", "Pipfile", ".git",
}

function M.root(bufnr)
  -- A standalone file without a project marker uses its containing directory.
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  return vim.fs.root(bufnr or 0, M.root_markers)
    or (file ~= "" and vim.fs.dirname(file)) or vim.fn.getcwd()
end

function M.executable(name, root)
  -- Prefer an explicitly activated environment, then the project's conventional .venv.
  -- Fall back to PATH so globally installed Flake8/Python remain usable.
  local environments = { vim.env.VIRTUAL_ENV or "", (root or M.root(0)) .. "/.venv" }
  for _, environment in ipairs(environments) do
    local candidate = environment .. "/bin/" .. name
    if environment ~= "" and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return vim.fn.exepath(name)
end

function M.setup()
  vim.diagnostic.config({
    -- Display messages beside code; identify the provider when more than one reports.
    virtual_text = { source = "if_many" },
    -- Include the provider in the full-message popup for Flake8/Pyright findings.
    float = { source = true },
    -- Show errors before less severe messages when diagnostics share a location.
    severity_sort = true,
  })
  -- Neovim loads lsp/pyright.lua and starts the external server for Python buffers.
  vim.lsp.enable("pyright")
end

return M
