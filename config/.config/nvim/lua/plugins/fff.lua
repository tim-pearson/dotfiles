return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {
    no_swap_file = true,
    keymaps = {
      close = { "<C-c>" },
    },
  },
  keymaps = {
    move_up = { "<Up>", "<C-p>" },
    move_down = { "<Down>", "<C-n>" },
    close = "<Esc>",
  },
  keys = {
    -- normal file picker (respects .gitignore)
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "Find files",
    },
  },
}
