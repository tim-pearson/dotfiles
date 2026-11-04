vim.opt.shell = "zsh"

local base_term = nil
local ruche_term = nil
local adastra_term = nil
local inti_term = nil

local function get_terminal(existing, opts)
  local Terminal = require("toggleterm.terminal").Terminal

  -- Recreate if:
  -- 1. doesn't exist
  -- 2. buffer is gone
  -- 3. job is dead
  if not existing or existing.bufnr == nil or existing.job_id == nil then
    return Terminal:new(opts)
  end

  return existing
end

local function toggle_base()
  base_term = get_terminal(base_term, {
    display_name = " BASE",
    count = 1,
    direction = "float",
    hidden = true,
  })
  base_term:toggle()
end

local function toggle_ruche()
  ruche_term = get_terminal(ruche_term, {
    display_name = " RUCHE",
    cmd = "ssh ruche",
    count = 2,
    direction = "float",
    hidden = true,
  })
  ruche_term:toggle()
end

local function toggle_adastra()
  adastra_term = get_terminal(adastra_term, {
    display_name = " ADASTRA",
    cmd = "ssh adastra || zsh",
    count = 3,
    direction = "float",
    hidden = true,
  })
  adastra_term:toggle()
end

local function toggle_inti()
  inti_term = get_terminal(inti_term, {
    display_name = " INTI",
    cmd = "ssh inti || zsh",
    count = 4,
    direction = "float",
    hidden = true,
  })
  inti_term:toggle()
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup()
  end,
  keys = {
    {
      "<M-i>",
      toggle_base,
      mode = { "n", "t" },
      desc = "ToggleTerm base",
    },
    {
      "<M-o>",
      toggle_ruche,
      mode = { "n", "t" },
      desc = "ToggleTerm ruche",
    },
    {
      "<M-p>",
      toggle_adastra,
      mode = { "n", "t" },
      desc = "ToggleTerm adastra",
    },
    {
      "<M-u>",
      toggle_inti,
      mode = { "n", "t" },
      desc = "ToggleTerm inti",
    },
  },
}
