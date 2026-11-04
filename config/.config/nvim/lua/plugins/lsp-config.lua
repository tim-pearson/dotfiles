local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

lspconfig.jedi_language_server.setup({
  init_options = {
    diagnostics = {
      enable = false,
    },
  },
})

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Ensure mason installs the server
      jedi_language_server = {
        root_dir = require("lspconfig.util").root_pattern(".git", "pyproject.toml", "setup.py", "requirements.txt"),

        init_options = {
          workspace = {},

          codeAction = {
            nameExtractVariable = "jls_extract_var",
            nameExtractFunction = "jls_extract_def",
          },

          completion = {
            disableSnippets = false,
            resolveEagerly = true,
          },

          diagnostics = {
            enable = false, -- ❗ disable to avoid duplication with Pyright
          },
        },

        settings = {
          python = {},
        },

        on_attach = function(client, bufnr)
          -- ✅ Jedi is your hover provider
          client.server_capabilities.hoverProvider = true

          -- ❌ no formatting from Jedi
          client.server_capabilities.documentFormattingProvider = false

          -- optional: ensure LSP hover is used
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
        end,
      },
      pyright = {
        root_dir = require("lspconfig.util").root_pattern(".git", "pyproject.toml", "setup.py", "requirements.txt"),

        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- or "off" if you want lighter checks
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },

        on_attach = function(client, bufnr)
          -- ❌ disable hover so it doesn't conflict with Jedi
          client.server_capabilities.hoverProvider = false

          -- ❌ Pyright doesn't format anyway, but be explicit
          client.server_capabilities.documentFormattingProvider = false
        end,
      },

      clangd = {
        keys = {
          { "<leader><Tab>", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac", -- AutoTools
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja",
          ".git",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          -- "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          -- "--fallback-style=llvm",
          "--inlay-hints=false",

          "--compile-commands-dir=build",
        },

        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
    },
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        return false
      end,
    },
  },
}
