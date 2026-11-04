-- return {
--   "stevearc/conform.nvim",
--   optional = true,

--   opts = function(_, opts)
--     opts.formatters_by_ft = opts.formatters_by_ft or {}

--     -- Python formatter
--     opts.formatters_by_ft.python = {

--       black = {
--         prepend_args = { "--line-length", "100" },
--       },
--     }

--     -- your existing extension (oxfmt)
--     local supported = opts.supported_ft or {}
--     for _, ft in ipairs(supported) do
--       opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
--       table.insert(opts.formatters_by_ft[ft], "oxfmt")
--     end

--     -- format-on-save (clean integration style)
--     opts.format_on_save = {
--       timeout_ms = 2000,
--       lsp_fallback = true,
--     }

--     return opts
--   end,
-- }
return {
  "stevearc/conform.nvim",
  optional = true,

  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- ✅ Select formatter (ONLY names here)
    opts.formatters_by_ft.python = { "black" }

    -- ✅ Configure formatter here
    opts.formatters = opts.formatters or {}
    opts.formatters.black = {
      prepend_args = { "--line-length", "100" },
    }

    -- your existing extension (oxfmt)
    local supported = opts.supported_ft or {}
    for _, ft in ipairs(supported) do
      opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      table.insert(opts.formatters_by_ft[ft], "oxfmt")
    end

    opts.format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = true,
    }

    return opts
  end,
}
