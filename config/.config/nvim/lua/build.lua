-- lua/build.lua
local M = {}
local job_id = nil
local term_buf = nil
local pending = ""
local BUILD_CMD = {
  "make",
  "-C",
  "build",
  "interpolator_tests",
}
local function strip_ansi(line)
  return line:gsub("\27%[[0-9;?]*[ -/]*[@-~]", "")
end
local function add_to_quickfix(data)
  if not data then
    return
  end
  local lines = {}
  for _, line in ipairs(data) do
    line = line:gsub("\r", "")
    if pending ~= "" then
      line = pending .. line
      pending = ""
    end
    lines[#lines + 1] = strip_ansi(line)
  end
  -- The final empty string means the previous line was complete.
  if data[#data] ~= "" then
    pending = lines[#lines]
    lines[#lines] = nil
  end
  if #lines == 0 then
    return
  end
  vim.fn.setqflist({}, "a", {
    lines = lines,
    efm = vim.o.errorformat,
  })
end
local function finish_build(exit_code)
  -- Flush any incomplete final line.
  if pending ~= "" then
    vim.fn.setqflist({}, "a", {
      lines = { strip_ansi(pending) },
      efm = vim.o.errorformat,
    })
    pending = ""
  end
  job_id = nil
  if exit_code == 0 then
    vim.notify("Build succeeded", vim.log.levels.INFO)
  elseif exit_code == 143 or exit_code == 130 then
    vim.notify("Build stopped", vim.log.levels.WARN)
  else
    vim.notify("Build failed (exit code " .. exit_code .. ")", vim.log.levels.ERROR)
  end
  -- Trouble has auto_refresh enabled by default.
  -- Refresh its qflist view explicitly if it is open.
  vim.schedule(function()
    pcall(vim.cmd, "Trouble refresh")
  end)
end
function M.build()
  -- Prevent multiple builds.
  if job_id then
    local status = vim.fn.jobwait({ job_id }, 0)[1]
    if status == -1 then
      vim.notify("Build already running (job " .. job_id .. ")", vim.log.levels.WARN)
      return
    end
    job_id = nil
  end
  pending = ""
  -- Completely replace the previous build's quickfix list.
  -- NOTE: when the {what} dict is passed, the positional {list} argument
  -- is ignored by Vim, so items must be cleared via the `items` key here,
  -- otherwise old entries from the previous build stick around.
  vim.fn.setqflist({}, "r", {
    title = "interpolator_tests",
    items = {},
  })
  -- Reuse the existing terminal buffer/window if we still have one,
  -- instead of always opening a new split.
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local win = vim.fn.bufwinid(term_buf)
    if win == -1 then
      vim.cmd("botright split")
      vim.api.nvim_win_set_buf(0, term_buf)
    else
      vim.api.nvim_set_current_win(win)
    end
    -- termopen() refuses to run on a buffer marked modified, which a
    -- terminal buffer becomes once its previous job exits.
    vim.bo[term_buf].modified = false
  else
    vim.cmd("botright split")
    vim.cmd("enew")
    term_buf = vim.api.nvim_get_current_buf()
    vim.bo.buflisted = false
    vim.bo.swapfile = false
    vim.bo.bufhidden = "hide"
    -- Don't show the terminal cursor as an underscore.
    vim.opt_local.guicursor = "a:Block"
  end
  vim.notify("Starting: make -C build interpolator_tests", vim.log.levels.INFO)
  job_id = vim.fn.termopen(BUILD_CMD, {
    on_stdout = function(_, data)
      add_to_quickfix(data)
    end,
    on_stderr = function(_, data)
      add_to_quickfix(data)
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        finish_build(exit_code)
      end)
    end,
  })
  if job_id <= 0 then
    vim.notify("Failed to start build", vim.log.levels.ERROR)
    job_id = nil
    return
  end
  vim.notify("Build started (job " .. job_id .. ")", vim.log.levels.INFO)
  -- Keep the terminal visible, but don't enter terminal insert mode.
  vim.cmd("stopinsert")
end
function M.stop()
  if not job_id then
    vim.notify("No build running", vim.log.levels.WARN)
    return
  end
  vim.notify("Stopping build " .. job_id, vim.log.levels.WARN)
  vim.fn.jobstop(job_id)
end
function M.quickfix()
  vim.cmd("copen")
end
vim.api.nvim_create_user_command("Build", function()
  M.build()
end, {})
vim.api.nvim_create_user_command("BuildStop", function()
  M.stop()
end, {})
vim.api.nvim_create_user_command("BuildQuickfix", function()
  M.quickfix()
end, {})
return M
