-- Editor settings belong here, using vim.opt or vim.g as appropriate.
-- Space starts our plugin shortcuts (for example, Space f f finds files).
-- Define it before lazy.nvim creates mappings so <leader> expands consistently.
vim.g.mapleader = " "

-- Use exact RGB colors for the selected themes; Kitty supports true color.
vim.opt.termguicolors = true

-- Share ordinary yanks, deletes, changes, and pastes with the desktop clipboard (+).
-- Neovim detects wl-copy/wl-paste on Wayland or xclip/xsel on X11 automatically.
-- Use unnamedplus so p reads desktop copies, keeping the primary selection (*) separate.
vim.opt.clipboard = "unnamedplus"
