-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- fuzzy find
vim.keymap.del("n", "<leader>ff")
--vim.keymap.del("n", "<leader>/")
-- Rebind to fff.nvim
vim.keymap.set("n", "<leader>ff", function()
  --require("fff").find_files()
  require("fzf-lua").files()
end, { desc = "Open file picker (fff)" })

-- refactor/rename
-- Override the default rename keymap
vim.keymap.set("n", "<leader>r", function()
  return vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename variable/function" })
end, { expr = true, desc = "Rename variable/function" })

-- diagnostics
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, { noremap = true, silent = true })
-- start/end function
vim.keymap.set("x", "qq", "[{", { desc = "Go to start of function" })
vim.keymap.set("x", "zz", "]}", { desc = "Go to end of function" })

--Spectre
vim.keymap.set("n", "<leader>w", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})

local ts_utils = require("config.util.treesitter_utils")

-- Copy current function
vim.keymap.set("n", "<leader>cf", ts_utils.copy_current_function, { desc = "Copy current function" })

-- Copy current file
vim.keymap.set("n", "<leader>cF", ts_utils.copy_current_file, { desc = "Copy current file" })

-- Delete current function
vim.keymap.set("n", "<leader>df", ts_utils.delete_current_function, { desc = "Delete current function" })

-- Comment current function
vim.keymap.set("n", "<leader>cc", ts_utils.comment_current_function, { desc = "Comment current function" })

-- maximaze term size
vim.keymap.set({ "n", "t" }, "<A-t>", function()
  vim.cmd("resize | vertical resize")
end, { desc = "Maximize current window" })

vim.keymap.set("n", "<leader>b", function()
  require("build").build()
end, { desc = "Build interpolator_tests" })



-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {
--   desc = "Terminal: enter normal mode",
-- })



vim.keymap.set("n", "<leader>fl", "<cmd>ObsidianFollowLink<cr>",
  { desc = "Follow Obsian Link" })
