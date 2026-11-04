return {
  "Thiago4532/mdmath.nvim",
  ft = { "markdown", "python", "tex", "codecompanion" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("mdmath").setup({

      diagnostics = false,
      math_patterns = {
        -- block math
        { start = "\\$\\$",                stop = "\\$\\$",              priority = 1 },

        -- equation environments
        { start = "\\\\begin{equation}",   stop = "\\\\end{equation}",   priority = 1 },
        { start = "\\\\begin{align}",      stop = "\\\\end{align}",      priority = 1 },
        { start = "\\\\begin{gather}",     stop = "\\\\end{gather}",     priority = 1 },
        { start = "\\begin{equation}",     stop = "\\end{equation}",     priority = 1 },
        { start = "\\begin{align}",        stop = "\\end{align}",        priority = 1 },
        { start = "\\begin{gather}",       stop = "\\end{gather}",       priority = 1 },

        -- optional star variants
        { start = "\\\\begin{equation%*}", stop = "\\\\end{equation%*}", priority = 1 },
        { start = "\\\\begin{align%*}",    stop = "\\\\end{align%*}",    priority = 1 },
      },
      server_path = "node",
      server_args = { os.getenv("HOME") .. "/.local/share/nvim/lazy/mdmath.nvim/mdmath-js/src/server.js" },
      foreground = "#5a966b",
      anticonceal = true,

      conceal_cursor = "",

      dynamic = true,
      dynamic_scale = 0.8,  -- Disable dynamic scaling
      internal_scale = 1.5, -- Double resolution for crisper text

      css = [[
          .math-render {
            min-width: 100% !important;
            margin: 4px 0 !important;
            padding: 8px !important;
            background-color: rgba(200,200,200,0.1);
            border-radius: 4px;
            overflow-x: auto !important;
            white-space: pre !important;  -- Changed from nowrap to pre
          }
          .math-render .katex-display {
            margin: 0.5em 0 !important;
            text-align: left !important;
          }
          .math-render .katex {
            font-size: 1.1em !important;
          }
        ]],
    })

    -- Add autocommand to prevent wrapping in markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "tex" },
      callback = function()
        vim.opt_local.wrap = false
        vim.opt_local.linebreak = false
      end,
    })
  end,
  init = function()
    vim.fn.jobstart({
      "node",
      vim.fn.expand("~/.local/share/nvim/lazy/mdmath.nvim/mdmath-js/src/server.js"),
    }, {
      detach = true,
      on_exit = function() end,
    })
  end,
}
