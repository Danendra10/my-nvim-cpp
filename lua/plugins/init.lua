return {
  -- Existing plugins...

  -- Mason plugins
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "clangd" }, -- Automatically install clangd for C++
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.clangd.setup({})
    end,
  },

  -- Completion plugins
  {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "cpp", "lua" },
        highlight = {
          enable = true,
        },
      }
    end,
  },
  { 
    'wakatime/vim-wakatime', 
    lazy = false 
  },
  {
    'OscarCreator/rsync.nvim',
    build = 'make',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
        require("rsync").setup()
    end,
    shell ='/bin/bash',
  },
  
  -- Clang Format
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        debug = true,
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.clang_tidy,
          null_ls.builtins.formatting.clang_format.with({
            extra_args = { "--style=file" },
          }),
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
          end
        end,
      })

      -- Set the keybinding globally
      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true }) -- Ensure async formatting
      end, { desc = "Format Code (null-ls)" })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("configs.conform")
    end,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
}
