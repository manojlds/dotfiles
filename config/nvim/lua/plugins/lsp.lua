return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local builtin = require("telescope.builtin")
          map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
          map("gr", builtin.lsp_references, "[G]oto [R]eferences")
          map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        end,
      })

      -- Capabilities for autocompletion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {},
        ts_ls = {},
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        -- Keep this false so older/newer Neovim combos don't explode in mason-lspconfig.
        automatic_enable = false,
      })

      local has_new_lsp_api = vim.lsp
        and vim.lsp.config ~= nil
        and type(vim.lsp.enable) == "function"

      local lspconfig = nil

      for server_name, server_opts in pairs(servers) do
        local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_opts or {})

        if has_new_lsp_api then
          vim.lsp.config(server_name, opts)
          vim.lsp.enable(server_name)
        else
          lspconfig = lspconfig or require("lspconfig")

          local legacy_name = server_name
          -- Older lspconfig used tsserver instead of ts_ls.
          if server_name == "ts_ls" and not lspconfig.ts_ls and lspconfig.tsserver then
            legacy_name = "tsserver"
          end

          if lspconfig[legacy_name] then
            lspconfig[legacy_name].setup(opts)
          else
            vim.notify(("LSP server config not found: %s"):format(legacy_name), vim.log.levels.WARN)
          end
        end
      end
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
}
