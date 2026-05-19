return {
  {
    "kawre/leetcode.nvim",
    --branch = "disable-x-requested-with-header",
    build = ":TSUpdate", -- if you have `nvim-treesitter` installed
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      "nvim-lua/plenary.nvim",
      --"MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "c",
      notifier = false,
      hooke = {
        ["enter"] = function()
          --vim.opt.winfixbuf = false
        end,
      },
    },
  },
}
