-- blink.cmp: automatic suggestions with a session-wide on/off switch.
-- Controls, dependencies, examples, and disabling: docs/completion.md.
local enabled = true -- Start each Neovim session with completion enabled.

local function toggle()
  enabled = not enabled
  -- Dismiss an open menu immediately when disabling; this never accepts an item.
  local cmp = package.loaded["blink.cmp"]
  if not enabled and cmp then cmp.hide() end
  vim.notify("Completion " .. (enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end

return {
  {
    "saghen/blink.cmp",
    -- Stay on the documented 1.x API; lazy-lock.json pins the installed release.
    version = "1.*",
    -- Set up before Python's native LSP starts so Blink advertises its capabilities.
    lazy = false,
    -- Tell lazy.nvim which setup module owns the options below.
    main = "blink.cmp",
    init = function()
      -- The command offers the same toggle as the normal-mode Space c c shortcut.
      vim.api.nvim_create_user_command("CompletionToggle", toggle, {
        desc = "Toggle completion for this Neovim session",
      })
    end,
    opts = {
      enabled = function()
        -- Limit suggestions to ordinary editing buffers, excluding search forms,
        -- terminals, directory editors, and other special buffers.
        return enabled and vim.bo.buftype == ""
      end,
      keymap = {
        -- Keep familiar controls: Ctrl-n/p and arrows select, Ctrl-y accepts.
        preset = "default",
        -- Insert mode: Enter accepts the highlighted suggestion; without a selection,
        -- fall back to normal newline/mini.pairs behavior.
        -- Blink supplies this mapping's desc field: "blink.cmp: Accept".
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        list = {
          -- Leave text untouched while browsing; insert only on explicit acceptance.
          selection = { preselect = false, auto_insert = false },
        },
        -- Show documentation after selecting a suggestion (upstream delay: 500 ms).
        documentation = { auto_show = true },
        -- mini.pairs owns typed bracket pairing; accepting a completion adds no extra brackets.
        accept = { auto_brackets = { enabled = false } },
      },
      sources = {
        -- Use Blink's bundled providers, including Pyright via LSP, without snippet packs.
        default = { "lsp", "path", "buffer" },
      },
      -- The Lua matcher needs neither a Rust toolchain nor a downloaded native binary.
      fuzzy = { implementation = "lua" },
      -- Keep command/search input and embedded shells on their existing completion behavior.
      cmdline = { enabled = false },
      term = { enabled = false },
    },
    keys = {
      -- Normal mode: the same key turns completion off and back on across all buffers.
      { "<leader>cc", toggle, mode = "n", desc = "Toggle completion" },
    },
  },
}
