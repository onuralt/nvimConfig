local M = {}

function M.setup()
  local lspconfig = require "lspconfig"
  local mason = require "mason"
  local mason_lspconfig = require "mason-lspconfig"
  local mason_tool_installer = require "mason-tool-installer"

  -- Mason: use a single, explicit registry (no duplicate warning)
  mason.setup {
    registries = { "github:mason-org/mason-registry" },
  }

  mason_lspconfig.setup()

  -- Do NOT auto-install ltex-ls (install it manually once via :MasonInstall ltex-ls)
  mason_tool_installer.setup {
    ensure_installed = {
      -- LSPs
      "lua-language-server",
      "clangd",
      "pyright",
      "texlab",
      "bash-language-server",
      "json-lsp",
      "yaml-language-server",
      "marksman",
      "taplo",
      "cmake-language-server",
      -- Formatters
      "stylua",
      "clang-format",
      "black",
      "isort",
      "prettierd",
      "shfmt",
      -- Linters
      "ruff",
      -- DAP
      "debugpy",
      "codelldb",
    },
    auto_update = false,
    run_on_start = false, -- don't block startup on flaky downloads
    start_delay = 3000,
  }

  -- nvim-cmp capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- On attach: keymaps
  local on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
    end
    map("n", "gd", function()
      require("telescope.builtin").lsp_definitions()
    end)
    map("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end)
    map("n", "gi", function()
      require("telescope.builtin").lsp_implementations()
    end)
    map("n", "gD", vim.lsp.buf.declaration)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    map("n", "<leader>e", vim.diagnostic.open_float)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
    map({ "n", "v" }, "<leader>f", function()
      require("conform").format { async = true }
    end)
  end

  -- Lua (Neovim config)
  local ok_neodev, neodev = pcall(require, "neodev")
  if ok_neodev then
    neodev.setup {}
  end
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- C/C++
  lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  }

  -- Python
  lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        analysis = { typeCheckingMode = "basic", autoImportCompletions = true },
      },
    },
  }

  -- LaTeX
  lspconfig.texlab.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      texlab = {
        build = { onSave = false },
        forwardSearch = { executable = "okular", args = { "--unique", "file:@pdf#src:@line@tex" } },
      },
    },
  }

  -- Grammar/spell: LTeX (start only if installed)
  if vim.fn.exepath "ltex-ls" ~= "" then
    lspconfig.ltex.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "tex", "bib", "markdown", "plaintex" },
      settings = {
        ltex = {
          language = "en-US",
          additionalRules = { motherTongue = "de-DE", enablePickyRules = true },
          checkFrequency = "save",
        },
      },
    }
  end

  -- Bash / JSON / YAML / Markdown / TOML / CMake
  lspconfig.bashls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.jsonls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.yamlls.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.marksman.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.taplo.setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig.cmake.setup { capabilities = capabilities, on_attach = on_attach }
end

return M
