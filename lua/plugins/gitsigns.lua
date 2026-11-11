-- Gitsigns: show Git changes beside lines and work with individual hunks.
-- Dependencies, controls, examples, and removal: docs/gitsigns.md.
return {
  {
    "lewis6991/gitsigns.nvim",
    -- Follow stable releases on manual updates; the lockfile records the exact commit.
    version = "*",
    -- Load when reading/creating a file so signs appear without opening a Git UI.
    event = { "BufReadPre", "BufNewFile" },
    -- Also allow explicit commands before any file has been opened.
    cmd = "Gitsigns",
    opts = {
      -- Keep upstream sign styles and automatic tracking; add only local controls.
      -- Attach-time mappings apply only to buffers Gitsigns can track in Git.
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          -- Limit each shortcut to this buffer and describe it for :map/help tools.
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Visit both staged and unstaged hunks; retain built-in diff navigation
        -- (including a numeric count) when the window is in Neovim's diff mode.
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ vim.v.count1 .. "]c", bang = true })
          else
            gitsigns.nav_hunk("next", { target = "all" })
          end
        end, "Next Git hunk")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ vim.v.count1 .. "[c", bang = true })
          else
            gitsigns.nav_hunk("prev", { target = "all" })
          end
        end, "Previous Git hunk")

        -- Preview before applying actions; stage_hunk also unstages a staged hunk.
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Git hunk")
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage or unstage Git hunk")
        -- Reset replaces the hunk's buffer text with the index version; u can undo it.
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Git hunk")
        -- Visual mode operates on selected lines, including part of a hunk.
        map("x", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage or unstage selected Git lines")
        map("x", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected Git lines")
        -- Request blame in a popup only when needed, using the upstream format.
        map("n", "<leader>hb", gitsigns.blame_line, "Blame current Git line")
      end,
    },
  },
}
