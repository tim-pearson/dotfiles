return {
  "sindrets/diffview.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
  },

  keys = {
    {
      "<leader>dm",
      function()
        -- Get current branch
        local current_handle = io.popen("git rev-parse --abbrev-ref HEAD")
        local current_branch = current_handle:read("*a"):gsub("\n", "")
        current_handle:close()

        -- Get list of branches (local only)
        local handle = io.popen("git branch --format='%(refname:short)'")
        if not handle then
          vim.notify("Failed to get git branches", vim.log.levels.ERROR)
          return
        end

        local branches = {}
        for branch in handle:lines() do
          branch = branch:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
          if branch ~= "" then
            table.insert(branches, branch)
          end
        end
        handle:close()

        if #branches == 0 then
          vim.notify("No branches found", vim.log.levels.WARN)
          return
        end

        -- Create UI list with current branch indicator
        vim.ui.select(branches, {
          prompt = "Select branch to diff against:",
          format_item = function(item)
            local marker = (item == current_branch) and " ✓ " or "   "
            return marker .. item
          end,
        }, function(choice)
          if not choice then
            return -- user cancelled
          end

          -- Open diffview with selected branch
          vim.cmd("DiffviewOpen " .. choice .. " -- %")

          -- Toggle file panel after a short delay
          vim.defer_fn(function()
            pcall(function()
              require("diffview.actions").toggle_files()
            end)
          end, 50)
        end)
      end,
      desc = "Diff file against branch (side-by-side, no panel)",
    },

    { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
  },
  opts = function()
    local actions = require("diffview.actions")

    return {
      enhanced_diff_hl = true,
      use_icons = true,
      show_help_hints = false,
      watch_index = false,

      view = {
        default = {
          layout = "diff2_hoizontal",
        },
      },

      file_panel = {
        listing_style = "tree",

        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },

        win_config = {
          position = "left",
          width = 32,
        },
      },

      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 12,
        },
      },

      keymaps = {

        disable_defaults = false,

        view = {
          { "n", "q", actions.close, { desc = "Close diffview" } },

          -- faster file traversal
          { "n", "<tab>", actions.select_next_entry },
          { "n", "<s-tab>", actions.select_prev_entry },

          -- toggle file tree
          { "n", "<leader>b", actions.toggle_files },

          -- cycle layouts
          { "n", "g<C-x>", actions.cycle_layout },

          -- open current file normally
          { "n", "gf", actions.goto_file_edit },

          -- conflicts
          { "n", "]x", actions.next_conflict },
          { "n", "[x", actions.prev_conflict },
        },

        file_panel = {
          { "n", "q", actions.close },

          { "n", "j", actions.next_entry },
          { "n", "k", actions.prev_entry },

          { "n", "<cr>", actions.select_entry },
          { "n", "o", actions.select_entry },
          { "n", "l", actions.select_entry },

          { "n", "h", actions.close_fold },

          { "n", "R", actions.refresh_files },

          { "n", "<leader>b", actions.toggle_files },

          { "n", "gf", actions.goto_file_edit },

          { "n", "g<C-x>", actions.cycle_layout },
        },
      },
    }
  end,
}
