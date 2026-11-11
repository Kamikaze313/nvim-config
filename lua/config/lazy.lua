-- lazy.nvim manages explicitly selected plugins; it does not import LazyVim.
-- The existing manager was copied here; on a new machine, bootstrap it once.
local plugin_root = vim.fn.stdpath("data") .. "/lazy-selected"
local lazypath = plugin_root .. "/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  -- Git downloads only the manager's stable branch, without historical blobs.
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    -- Keep the editor usable if installation fails; report how to retry.
    vim.notify("lazy.nvim installation failed. Check Git/network access and restart Neovim.\n" .. output,
      vim.log.levels.ERROR)
    return
  end
end

-- Expose the manager's Lua module to require().
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Explicit imports keep the list limited to features selected by the user.
  spec = {
    { import = "plugins.telescope" }, -- File, text, buffer, history, and help search.
    { import = "plugins.oil" }, -- Browse directories and edit file names as a buffer.
    { import = "plugins.gitsigns" }, -- Git change markers and per-hunk actions.
    { import = "plugins.which-key" }, -- Discover shortcuts in a popup after pausing.
    { import = "plugins.explorer" }, -- Project file sidebar with Snacks' bundled picker.
    { import = "plugins.everforest" }, -- Optional palette in the two-choice theme menu.
  },

  -- Keep new plugins separate so manager cleanup cannot remove the old setup's plugins.
  root = plugin_root,

  -- Ignore project .lazy.lua files: this configuration owns the plugin list.
  local_spec = false,

  -- Installation is explicit through :Lazy install, rather than during startup.
  install = { missing = false },

  -- Fetch updates only when requested through :Lazy check or :Lazy update.
  checker = { enabled = false },

  -- Restart after configuration edits; no automatic spec reloads or change notices.
  change_detection = { enabled = false },

  -- No selected plugin needs LuaRocks; avoid its additional toolchain.
  rocks = { enabled = false },
})
