return {
  "Kurama622/llm.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "LLMSessionToggle",
    "LLMSelectedTextHandler",
    "LLMAppHandler",
  },

  config = function()
    require("llm").setup({
      url = "https://openrouter.ai/api/v1/chat/completions",
      model = "openrouter/free",
      api_type = "openai",

      fetch_key = function()
        return os.getenv("LLM_KEY")
      end,

      max_tokens = 2048,
      temperature = 0.7,
    })
  end,

  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
  },
}
