-- Snacks Explorer: a project file tree beside the code, toggled with Space e.
-- Dependencies, navigation, file operations, and removal: docs/explorer.md.
return {
  {
    "folke/snacks.nvim",
    -- Follow stable releases on manual updates; lazy-lock.json records the commit.
    version = "*",
    -- Snacks recommends early setup; the sidebar itself opens only on request.
    lazy = false,
    priority = 1000,
    opts = {
      explorer = {
        -- Enable the selected file explorer and its file-operation helpers.
        enabled = true,
        -- Oil owns directory buffers such as `nvim .`; Snacks opens via Space e.
        replace_netrw = false,
      },
      picker = {
        -- The explorer is implemented by Snacks' bundled picker, not another plugin.
        enabled = true,
        -- Keep Neovim's general selection dialogs unchanged outside the explorer.
        ui_select = false,
        -- Use a readable search prompt without requiring a Nerd Font.
        prompt = "> ",
        sources = {
          explorer = {
            -- Keep the tree on the left, without a preview covering the code.
            layout = { preset = "sidebar", preview = false },
            -- Opening a file leaves the tree visible for further navigation.
            jump = { close = false },
            icons = {
              -- File names and tree lines work without an icon plugin or special font.
              files = { enabled = false },
              -- Use Git status letters instead of font-specific status symbols.
              git = { enabled = false },
              -- Use readable markers when searching or selecting multiple files.
              ui = { live = "*", selected = "[x] ", unselected = "[ ] " },
              -- Native diagnostics, when present, also use plain-text labels.
              diagnostics = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " },
            },
          },
        },
      },
      input = {
        -- Explorer uses this bundled helper for file-operation prompts; do not
        -- replace vim.ui.input globally or enable a separate input-UI feature.
        enabled = false,
        -- Explorer's own prompts remain readable without a special icon font.
        icon = "",
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          -- Match the old project-root shortcut using Neovim's native root lookup.
          -- If no Git root is found, browse the current working directory.
          local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
          -- Snacks toggles an existing explorer in this tab when called again.
          Snacks.explorer({ cwd = root })
        end,
        -- Normal mode only; which-key can display this description automatically.
        mode = "n",
        desc = "Toggle project file explorer",
      },
    },
  },
}
