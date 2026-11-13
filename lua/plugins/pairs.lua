-- mini.pairs: automatically insert matching brackets and quotes while editing.
-- Controls, dependencies, limitations, and removal: docs/pairs.md.
return {
  {
    -- Install this module's standalone repository, without the rest of mini.nvim.
    "nvim-mini/mini.pairs",
    -- Follow stable releases on manual updates; lazy-lock.json records the commit.
    version = "*",
    -- Set up at startup so the upstream FileType exclusions exist before a search
    -- prompt opens, including when Telescope is the first thing used in a session.
    lazy = false,
    -- Identify the Lua setup module explicitly for lazy.nvim's opts handling.
    main = "mini.pairs",
    opts = {
      modes = {
        -- Pair brackets/quotes while editing text, using upstream mappings and rules.
        insert = true,
        -- Keep Ex commands and search expressions as literal command-line input.
        command = false,
        -- Let shells and terminal programs manage their own input.
        terminal = false,
      },
    },
  },
}
