-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.autocmds")
require("build")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/texpresso/build")
vim.env.TEXPRESSO_TECTONIC = vim.fn.expand("~/.local/bin/tectonic")
-- vim.g.texpresso_use_json = 1
-- vim.g.texpresso_use_lines = 1 -- force line-based mode
--
