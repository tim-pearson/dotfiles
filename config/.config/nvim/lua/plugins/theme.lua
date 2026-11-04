vim.g.terminal_color_4 = "#5f87ff" -- blue, directories
vim.g.terminal_color_6 = "#5fafaf" -- cyan
vim.g.terminal_color_2 = "#87af5f" -- green
vim.g.terminal_color_3 = "#d7af5f" -- yellow
return {
  "metalelf0/black-metal-theme-neovim",
  lazy = false,
  priority = 1000,
  config = function()
    require("black-metal").setup({
      -- optional configuration here

      term_colors = false,
    })
    require("black-metal").load()
  end,
}
