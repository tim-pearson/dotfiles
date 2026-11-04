return {
  "tpope/vim-commentary",
  lazy = false,
  keys = {
    { "<leader>/", "<Plug>CommentaryLine", desc = "Toggle comment", mode = "n" },
    { "<leader>/", "<Plug>Commentary", desc = "Toggle comment", mode = "v" },
  },
}
