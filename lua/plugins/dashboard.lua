return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,

        sections = {
          {
            section = "header",
            align = "center",
          },
          {
            section = "keys",
            gap = 1,
          },
          {
            section = "startup",
          },
        },

        preset = {
          header = [[
   _____,,;;;`;       ;';;;,,_____
,~(  )  , )~~\|       |/~~( ,  (  )~;
' / / --`--,             .--'-- \ \ `
 /  \    | '             ` |    /  \ 
          user:najid@kamikaze        
          ]],
        },
      },
    },
  },
}
