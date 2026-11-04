return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  opts = {
    defaults = {
      preview = {
        treesitter = false,
      },
    },
  },

  -- tag = "0.1.5",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- {
    --   "<leader>fz",
    --   function()
    --     require("telescope.builtin").find_files({
    --       cwd = "results/plots",
    --       find_command = { "fd", "--type", "f", "--extension", "png" },
    --       hidden = true,
    --       no_ignore = true, -- ignore gitignore
    --     })
    --   end,
    --   desc = "Browse plots (png in ignored folder telescope)",
    -- },

    { "<leader>/", false },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Find quickfix" },
    { "<leader>fc", "<cmd>Telescope grep_string search=<<<<<<CR>", desc = "Find merge conflict" },
    { "<leader>ft", "<cmd>Telescope grep_string search=TODO<CR>", desc = "Find TODOs" },
    { "<leader>fa", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find all" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keys" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
    { "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "Find in files" },
    { "<leader>fm", "<cmd>Telescope man_pages sections={'ALL'}<CR>", desc = "Man page" },
  },
}
