-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    image = {
      math = {
        enabled = false,
      },
      enabled = true,
      -- only render non-math images
      filter = function(path)
        return not path:match("math")
      end,
      doc = {
        inline = true, -- never render inline
        float = false, -- floating window
        max_width = 60,
        max_height = 30,
        -- float_config pins to top-right corner
        float_config = {
          relative = "editor",      -- position relative to entire Neovim window
          row = 0,                  -- top row
          col = vim.o.columns - 61, -- right-aligned, accounting for max_width
          anchor = "NW",            -- anchor top-left corner
          style = "minimal",        -- no decorations
          border = "single",        -- optional border
        },
        -- conceal math images just in case
        conceal = function(_, type)
          return type == "math"
        end,
      },
    },

    -- window options for image buffers
    wo = {
      wrap = false,
      number = false,
      relativenumber = false,
      cursorcolumn = false,
      signcolumn = "no",
      foldcolumn = "0",
      list = false,
      spell = false,
      statuscolumn = "",
    },

    picker = {
      win = {
        input = {
          keys = {
            ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        ---@param p snacks.Picker
        toggle_cwd = function(p)
          local root = LazyVim.root({ buf = p.input.filter.current_buf, normalize = true })
          local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
          local current = p:cwd()
          p:set_cwd(current == root and cwd or root)
          p:find()
        end,
      },
    },
  },

  keys = {
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    { "<leader>fc", false },
    -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
    { "<leader>ff", LazyVim.pick("files"),                   desc = "Find Files (Root Dir)" },
    { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fr", LazyVim.pick("oldfiles"),                desc = "Recent" },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff (hunks)",
    },
    {
      "<leader>gD",
      function()
        Snacks.picker.git_diff({ base = "origin", group = true })
      end,
      desc = "Git Diff (origin)",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gS",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git Stash",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
    { "<leader>sb", false },
  },
}
