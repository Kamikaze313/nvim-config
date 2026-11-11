-- Oil: browse directories and apply file operations by editing a buffer.
-- Usage, confirmation controls, and removal instructions: docs/oil.md.
return {
  {
    "stevearc/oil.nvim",
    -- Follow stable releases on manual updates; lazy-lock.json records the exact commit.
    version = "*",
    -- Oil recommends startup loading so directory arguments and :edit paths work reliably.
    lazy = false,
    opts = {
      -- Use Oil when opening directories, including `nvim .` and `:edit src/`.
      default_file_explorer = true,
      -- Show names without extra columns, avoiding an icon-plugin dependency.
      columns = {},
      -- Review file operations on :write, including a single rename or creation.
      skip_confirm_for_simple_edits = false,
    },
    keys = {
      -- Normal mode: open the current file's parent (or cwd for an unnamed buffer).
      -- Inside Oil, its buffer-local '-' mapping goes up one directory.
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },
}
