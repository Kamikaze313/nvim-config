-- Noice: a top-center command input; Blink provides the completion dropdown.
-- Controls, dependencies, automatic behavior, and removal: docs/command-line.md.
return {
  {
    -- Install only the selected command UI, without a distribution or notification plugin.
    "folke/noice.nvim",
    -- Attach after startup so ordinary settings and the selected theme are ready.
    event = "VeryLazy",
    -- Nui draws Noice's floating input and border; it is a required rendering helper.
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        -- Render : commands in the floating input defined below.
        view = "cmdline_popup",
        format = {
          -- Keep / and ? searches at the bottom, using Noice's plain command view.
          search_down = { view = "cmdline" },
          search_up = { view = "cmdline" },
          -- Keep input() dialogs and expression-register input in the bottom view too.
          input = { view = "cmdline" },
          calculator = { view = "cmdline" },
        },
      },
      views = {
        cmdline_popup = {
          -- Place the command input near the top and center it horizontally.
          position = { row = 3, col = "50%" },
          size = {
            width = "60%", -- Scale with the editor width so smaller terminals still fit.
            min_width = 0, -- Override Noice's fixed 60-column minimum for narrow terminals.
          },
          -- Rounded edges match the selected floating command-palette design.
          border = { style = "rounded" },
        },
      },
      -- Blink owns the suggestion dropdown, so Noice should not draw another one.
      popupmenu = { enabled = false },
      -- Keep command output, errors, and message history in Neovim's native message UI.
      messages = { enabled = false },
      -- Preserve the existing notification behavior; no notifier is selected here.
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false }, -- Keep this feature from adding LSP progress popups.
        hover = { enabled = false }, -- Keep native hover documentation.
        signature = { enabled = false }, -- Keep the current signature-help behavior.
        message = { enabled = false }, -- Keep language-server messages on their existing route.
      },
    },
  },
}
