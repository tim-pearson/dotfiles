vim.g.iron_repl_split = "horizontal botright 15 split" -- default vertical split

return {
  "Vigemus/iron.nvim",
  event = "VeryLazy",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {

        repl_definition = {
          sh = {
            command = { "zsh" },
          },

          python = {
            command = { "ipython", "--no-autoindent" },
            -- command = { "python", "manage.py", "shell" },
            format = require("iron.fts.common").bracketed_paste,
            block_dividers = { "# %%", "#%%" },
          },
          django = {
            command = { "python", "manage.py", "shell" },
            format = require("iron.fts.common").bracketed_paste,
            block_dividers = { "# %%", "#%%" },
          },
          lua = {
            command = { "lua" },
          },
          javascript = {
            command = { "node" },
          },
          typescript = {
            command = { "ts-node" },
          },
          r = {
            command = { "R" },
          },
          julia = {
            command = { "julia" },
          },
        },
        -- repl_open_cmd = view.right("40%"), -- ⬅️ this opens REPL on right in a vertical split

        scratch_repl = true,
        repl_open_cmd = vim.g.iron_repl_split,

        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      },
      keymaps = {
        send_code_block_and_move = "<Leader>sb",
        send_motion = "<Leader>sc",
        visual_send = "<Leader>sc",
        send_file = "<Leader>sf",
        send_line = "<Leader>sl",
        send_paragraph = "<Leader>sp",
        send_until_cursor = "<Leader>su",
        send_mark = "<Leader>sm",
        mark_motion = "<Leader>mc",
        mark_visual = "<Leader>mc",
        remove_mark = "<Leader>md",
        cr = "<Leader>s<cr>",
        interrupt = "<Leader>s<Leader>",
        exit = "<Leader>sq",
        clear = "<Leader>cl",
        toggle_repl = "<Leader>ti",
        restart_repl = "<Leader>rr",
      },
    })

    -- Additional commands
    vim.keymap.set("n", "<Leader>rf", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<Leader>rh", "<cmd>IronHide<cr>")
    vim.keymap.set("n", "<Leader>rl", "<cmd>IronRepl<cr>")
  end,
}
