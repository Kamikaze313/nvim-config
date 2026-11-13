-- Native LSP configuration; no nvim-lspconfig or Mason plugin is needed.
local python = require("config.python")

return {
  -- Run the selected Pyright server installed through npm, using standard LSP I/O.
  cmd = { "pyright-langserver", "--stdio" },
  -- Attach only to Python buffers, leaving other languages for future selections.
  filetypes = { "python" },
  -- Treat these project markers equally so the nearest project owns its environment.
  root_markers = { python.root_markers },
  settings = {
    python = {
      analysis = {
        -- Catch common type mistakes without adopting strict checking by default.
        typeCheckingMode = "basic",
        -- Report diagnostics for open files while still analyzing their imports.
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  before_init = function(_, config)
    -- Resolve installed packages against the active/project Python environment.
    -- System python3 is the fallback on machines without a `python` executable.
    local executable = python.executable("python", config.root_dir)
    if executable == "" then
      executable = python.executable("python3", config.root_dir)
    end
    if executable ~= "" then
      config.settings.python.pythonPath = executable
    end
  end,
  on_attach = function(_, bufnr)
    -- Normal mode in attached Python buffers: jump to a definition and return with Ctrl-o.
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = "Go to Python definition",
    })
  end,
}
