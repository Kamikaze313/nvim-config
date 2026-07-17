-- 1. Load LazyVim/Plugins first
require("config.lazy")

-- 2. THE MASTER UNLOCK (Fixes E1513)
-- This forces 'winfixbuf' to OFF every time you switch windows or buffers.
-- This overrides plugins like snacks.nvim that try to lock your layout.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.opt.winfixbuf = false
  end,
})
vim.opt.clipboard = "unnamedplus"
-- vim.g.clipboard = {
--   name = 'win32yank-wsl',
--   copy = {
--     ['+'] = 'win32yank.exe -i --crlf',
--     ['*'] = 'win32yank.exe -i --crlf',
--   },
--   paste = {
--     ['+'] = 'win32yank.exe -o --lf',
--     ['*'] = 'win32yank.exe -o --lf',
--   },
--   cache_enabled = 0,
-- }
