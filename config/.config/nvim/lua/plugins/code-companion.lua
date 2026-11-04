return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = {
    adapters = {
      http = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:3b",
              },
            },
          })
        end,

        openrouter = function()
          return require("codecompanion.adapters").extend("openrouter", {
            schema = {
              model = {
                default = "deepseek/deepseek-v4-flash",
              },
            },
          })
        end,
      },
    },

    interactions = {
      chat = {
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
      },
      cmd = {
        adapter = "ollama",
      },
    },
  },
}
