-- Entry point: Neovim loads this file on startup.
-- Load settings first, then shortcuts and automatic actions, so later modules
-- can rely on earlier choices, including the leader key used by plugin shortcuts.
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Start only the selected plugin manager after our editor configuration.
-- It loads only selected features; see docs/plugin-manager.md.
require("config.lazy")

-- Show diagnostics and enable the selected Python language server through native LSP.
require("config.python").setup()

-- Restore the selected colorscheme after lazy.nvim can load theme plugins on demand.
require("config.theme").setup()
