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
        menu = {
          cmdline_position = function()
            -- Noice publishes the input's screen position; leave its bottom border
            -- between the input and Blink's dropdown (row is 1-indexed, col is 0-indexed).
            -- Noice leaves that global behind on disable; use it only while its UI runs.
            local noice = package.loaded["noice.config"]
            local pos = noice and noice.is_running() and vim.g.ui_cmdline_pos
            if pos then return { pos[1], pos[2] } end
            -- With Noice disabled, retain Blink's native bottom-command positioning.
            local height = vim.o.cmdheight == 0 and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
        },
      },
      sources = {
        -- Use Blink's bundled providers, including Pyright via LSP, without snippet packs.
        default = { "lsp", "path", "buffer" },
      },
      -- The Lua matcher needs neither a Rust toolchain nor a downloaded native binary.
      fuzzy = { implementation = "lua" },
      cmdline = {
        -- Register command-line completion; the sources function limits it to : commands.
        enabled = true,
        sources = function()
          -- Reuse Blink's bundled command/argument provider and the existing session toggle.
          -- Searches and input() prompts receive no Blink candidates.
          return enabled and vim.fn.getcmdtype() == ":" and { "cmdline" } or {}
        end,
        keymap = {
          preset = "none", -- Define command controls separately from insert-mode Enter acceptance.
          ["<C-Space>"] = { "show", "fallback" }, -- Request a command suggestion menu manually.
          ["<C-n>"] = { "select_next", "fallback" }, -- Highlight the next candidate without inserting.
          ["<C-p>"] = { "select_prev", "fallback" }, -- Highlight the previous candidate without inserting.
          ["<Down>"] = { "select_next", "fallback" }, -- Use arrow keys to browse an open dropdown.
          ["<Up>"] = { "select_prev", "fallback" }, -- Native command history is the fallback without a menu.
          ["<Tab>"] = { "select_next", "fallback" }, -- Browse forward when the dropdown is visible.
          ["<S-Tab>"] = { "select_prev", "fallback" }, -- Browse backward when the dropdown is visible.
          ["<C-y>"] = { "select_and_accept", "fallback" }, -- Fill the selected/first candidate; do not execute it.
          ["<C-e>"] = { "hide", "fallback" }, -- Dismiss candidates while keeping the command input open.
          ["<CR>"] = { "accept_and_enter", "fallback" }, -- Run an explicitly selected suggestion; otherwise execute exactly the typed command.
          -- Blink generates desc fields for these mappings; Esc retains native cancellation.
        },
        completion = {
          -- Showing suggestions selects nothing; arrows select without changing the typed command.
          list = { selection = { preselect = false, auto_insert = false } },
          menu = { auto_show = true }, -- Open the dropdown as matching commands/arguments are typed.
          ghost_text = { enabled = false }, -- Keep predictions in the dropdown rather than inline.
        },
      },
      -- Embedded shell input keeps its existing native behavior.
      term = { enabled = false },
    },
    keys = {
      -- Normal mode: the same key turns completion off and back on across all buffers.
      { "<leader>cc", toggle, mode = "n", desc = "Toggle completion" },
    },
  },
}
