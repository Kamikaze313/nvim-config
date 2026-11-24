-- lualine: an icon-based mode indicator, filename, and cursor position.
-- Controls, Nerd Font requirements, customization, and removal: docs/statusline.md.
-- Translate lualine's mode names rather than raw keys so mode variants stay covered.
local mode_icons = {
  NORMAL = "", -- Neovim logo: navigate and run normal-mode actions.
  INSERT = "", -- Pencil: type text, including completion submodes.
  VISUAL = "", -- Eye: a characterwise selection is active.
  ["V-LINE"] = "", -- Use the same eye for a whole-line selection.
  ["V-BLOCK"] = "", -- Use the same eye for a rectangular selection.
  SELECT = "", -- Copy sheets: a selection that typing can replace.
  ["S-LINE"] = "", -- Keep linewise Select consistent with characterwise Select.
  ["S-BLOCK"] = "", -- Keep blockwise Select consistent with characterwise Select.
  REPLACE = "", -- Exchange arrows: typing overwrites existing text.
  ["V-REPLACE"] = "", -- Use the same arrows for virtual Replace.
  ["O-PENDING"] = "", -- Hourglass: an operator is waiting for a motion.
  COMMAND = "", -- Prompt: enter an Ex command or a search.
  EX = "", -- Keep Ex mode consistent with the command-line indicator.
  MORE = "", -- Ellipsis: Neovim is waiting at a more prompt.
  CONFIRM = "", -- Question mark: respond to a confirmation prompt.
  SHELL = "", -- Console: an external shell command is running.
  TERMINAL = "", -- Console: input goes to the embedded terminal.
}

return {
  {
    -- Install only this selected statusline plugin, without an icon dependency.
    "nvim-lualine/lualine.nvim",
    -- Display the bar just after startup, once the saved colorscheme is restored.
    event = "VeryLazy",
    init = function()
      -- The bar already identifies the mode; avoid a duplicate -- INSERT -- message.
      vim.opt.showmode = false
    end,
    opts = {
      options = {
        -- Follow the selected colorscheme and recolor automatically when it changes.
        theme = "auto",
        -- Keep one bar across the bottom rather than one under every split/sidebar.
        globalstatus = true,
        -- Angled edges on the left/right colored sections give the Powerline look.
        section_separators = { left = "", right = "" },
        -- The minimal sections need no extra dividers between individual components.
        component_separators = "",
      },
      sections = {
        -- Keep lualine's mode-aware colors but replace the uppercase label with a glyph.
        lualine_a = {
          {
            "mode", -- Use the built-in component so changes track Neovim's actual mode.
            fmt = function(name)
              -- Leave any future unknown mode readable instead of showing a wrong icon.
              return mode_icons[name] or name
            end,
          },
        },
        lualine_b = {}, -- Keep the requested bar compact without default Git/diagnostic counts.
        lualine_c = { "filename" }, -- Show the basename with built-in [+] modified/[-] readonly markers.
        lualine_x = {}, -- Omit the default encoding, file-format, and file-type labels.
        lualine_y = {}, -- Omit the percentage so cursor position is the only right-side detail.
        lualine_z = { "location" }, -- Show line:column in the colored section on the right.
      },
    },
  },
}
