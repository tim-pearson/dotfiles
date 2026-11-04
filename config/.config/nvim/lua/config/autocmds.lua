-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.md",
--   callback = function()
--     vim.fn.system(
--       "prettier --write --prose-wrap always --print-width 100 " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
--     )
--   end,
-- })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.md",
--   callback = function()
--     vim.cmd("silent !npx prettier --write --prose-wrap always --print-width 100 %")
--     vim.cmd("edit!")
--   end,
-- })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tex",
  callback = function()
    vim.fn.jobstart({
      "pdflatex",
      "-shell-escape",
      "-interaction=nonstopmode",
      "main.tex",
    }, {
      cwd = "/home/tim/workspace/mdls/latex_sfe_mdls/presenation",
      detach = true,
    })
  end,
})


vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    if ft == "kitty-scrollback" or ft == "zsh" then
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "KittyScrollbackLaunch",
  callback = function()
    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        if vim.bo.filetype == "zsh" then
          vim.wo.number = true
          vim.wo.relativenumber = true
        end
      end,
    })
  end,
})





local lint = require("lint")


lint.linters_by_ft = {
  python = { "pylint" },
}

local pylint = lint.linters.pylint

pylint.condition = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for _, line in ipairs(lines) do
    if line:match("^# %%%% %[markdown%]") then
      return false
    end
  end

  return true
end
