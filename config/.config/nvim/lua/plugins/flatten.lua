return {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
  opts = {
    window = {
      open = "alternate",
    },
    hooks = {
      post_open = function()
        vim.cmd("stopinsert")
      end,
    },
  },
}
