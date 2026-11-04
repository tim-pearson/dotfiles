local M = {}

-- Modern Neovim Tree-sitter API (replaces nvim-treesitter.ts_utils)
local ts = vim.treesitter

local function get_function_node()
  local node = ts.get_node()

  if not node then
    return nil
  end

  -- climb AST until function-like node
  while
    node
    and node:type() ~= "function"
    and node:type() ~= "function_definition"
    and node:type() ~= "method_definition"
  do
    node = node:parent()
  end

  return node
end

function M.copy_current_function()
  local node = get_function_node()

  if not node then
    vim.notify("No function node found", vim.log.levels.WARN)
    return
  end

  local start_row, _, end_row, _ = node:range()

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  local text = table.concat(lines, "\n")

  vim.fn.setreg("+", text)
  vim.notify(string.format("Copied function lines %d to %d", start_row + 1, end_row + 1))
end

function M.copy_current_file()
  local line_count = vim.api.nvim_buf_line_count(0)

  local lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)
  local text = table.concat(lines, "\n")

  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)

  vim.notify("Copied entire file (" .. line_count .. " lines) to clipboard", vim.log.levels.INFO)
end

function M.delete_current_function()
  local node = get_function_node()

  if not node then
    vim.notify("No function node found", vim.log.levels.WARN)
    return
  end

  local start_row, _, end_row, _ = node:range()

  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, {})
  vim.notify("Deleted function lines " .. (start_row + 1) .. " to " .. (end_row + 1))
end

function M.comment_current_function()
  local node = get_function_node()

  if not node then
    vim.notify("No function node found", vim.log.levels.WARN)
    return
  end

  local start_row, _, end_row, _ = node:range()
  local bufnr = vim.api.nvim_get_current_buf()

  local commentstring = vim.bo.commentstring
  if not commentstring or commentstring == "" then
    vim.notify("No commentstring set for this filetype", vim.log.levels.WARN)
    return
  end

  local comment_prefix = commentstring:match("^(.-)%%s")
  if not comment_prefix then
    vim.notify("Invalid commentstring format", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

  for i, line in ipairs(lines) do
    if line:match("%S") then
      lines[i] = comment_prefix .. " " .. line
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, false, lines)

  vim.notify(string.format("Commented function lines %d to %d", start_row + 1, end_row + 1))
end
return M
