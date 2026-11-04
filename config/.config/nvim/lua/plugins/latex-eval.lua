return {
  "tim-pearson/latex-eval.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for async operations
  },
  -- Define keymaps using the `keys` field
  keys = {
    {
      "<leader>zx",
      function()
        require("latex-eval").evaluate_visual()
      end,
      mode = "v",
      desc = "Evaluate LaTeX visual selection",
      ft = { "tex", "markdown" }, -- Only register these keymaps for tex/markdown files
    },
    {
      "<leader>zs",
      function()
        require("latex-eval").evaluate_visual(true)
      end,
      mode = "v",
      desc = "Simplify LaTeX visual selection",
      ft = { "tex", "markdown" },
    },
    {
      "<leader>zz",
      function()
        require("latex-eval").solve_visual()
      end,
      mode = "v",
      desc = "Solve LaTeX visual selection",
      ft = { "tex", "markdown" },
    },
    {
      "<leader>zd",
      function()
        require("latex-eval").diff_visual()
      end,
      mode = "v",
      desc = "Differentiate LaTeX visual selection",
      ft = { "tex", "markdown" },
    },
  },
  config = function()
    -- Register Which-Key group
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "markdown" },
      callback = function()
        require("which-key").add({
          ["<leader>z"] = { name = "+LatexEval" },
        }, { mode = "v" })
      end,
    })
  end,
}
