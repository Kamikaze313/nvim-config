-- Which-key: discover available shortcuts by pausing after a prefix such as Space.
-- Dependencies, popup controls, examples, and removal: docs/which-key.md.
return {
  {
    "folke/which-key.nvim",
    -- Follow stable releases on manual updates; the lockfile records the exact commit.
    version = "*",
    -- Set up hints just after startup so existing mappings are available to inspect.
    event = "VeryLazy",
    -- Also support opening the helper explicitly before the startup event runs.
    cmd = "WhichKey",
    opts = function()
      -- Replace the default special-key glyphs with text; no Nerd Font is needed.
      local key_labels = {
        Up = "Up", Down = "Down", Left = "Left", Right = "Right",
        C = "Ctrl-", M = "Alt-", D = "Super-", S = "Shift-",
        CR = "Enter", Esc = "Esc", NL = "Enter", BS = "Backspace",
        Space = "Space", Tab = "Tab",
        ScrollWheelDown = "ScrollDown", ScrollWheelUp = "ScrollUp",
      }
      -- Function keys also use readable names instead of font-specific symbols.
      for number = 1, 12 do
        key_labels["F" .. number] = "F" .. number
      end
      return {
        -- Wait 200 milliseconds before showing hints, including built-in key help.
        -- This controls the popup delay without changing Neovim's mapping timeout.
        delay = 200,
        icons = {
          -- Show action descriptions without icons or additional icon plugins.
          mappings = false,
          -- Use the plain-text special-key labels defined above throughout the popup.
          keys = key_labels,
        },
        spec = {
          -- Label existing normal-mode Telescope shortcuts; no new action is mapped.
          { "<leader>f", group = "Find", mode = "n" },
          -- Label the selected current-file/project replacement shortcuts.
          { "<leader>s", group = "Search / replace", mode = "n" },
          -- Label manual linting and the completion on/off switch.
          { "<leader>c", group = "Code", mode = "n" },
          -- Label Git actions in normal and visual modes; actions remain buffer-local.
          { "<leader>h", group = "Git hunks", mode = { "n", "x" } },
          -- Label the selected appearance control without creating another action.
          { "<leader>u", group = "Appearance", mode = "n" },
        },
      }
    end,
  },
}
