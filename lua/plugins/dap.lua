return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "williamboman/mason.nvim",
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason").setup()

      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = {
          "codelldb",
        },
      })

      dapui.setup()

      require("nvim-dap-virtual-text").setup()

      -- Open UI when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end


      -- codelldb adapter
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data")
            .. "/mason/packages/codelldb/extension/adapter/codelldb",
          args = {
            "--port",
            "${port}",
          },
        },
      }


      -- C debugging
      dap.configurations.c = {
        {
          name = "Launch C program",
          type = "codelldb",
          request = "launch",

          program = function()
            return vim.fn.input(
              "Executable: ",
              vim.fn.getcwd() .. "/",
              "file"
            )
          end,

          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }


      -- C++ uses the same config
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}
