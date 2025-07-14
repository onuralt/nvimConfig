dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"
local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end
end

-- disable semantic tokens
M.on_init = function(client, _)
  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = cmp_nvim_lsp.default_capabilities()

local lspconfig = require "lspconfig"
-- lua language server was renamed from sumneko_lua to lua_ls in newer
-- versions of nvim-lspconfig. fall back to the old name if needed.
local lua_server = lspconfig.lua_ls or lspconfig.sumneko_lua

if lua_server then
  lua_server.setup {
    on_init = M.on_init,
    on_attach = M.on_attach,
    capabilities = M.capabilities,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end

-- configure Ruff (Python linter) via LSP
if require("lspconfig.configs")["ruff"] == nil then
  require("lspconfig.configs")["ruff"] = {
    default_config = {
      cmd = { "ruff-lsp" },
      filetypes = { "python" },
      root_dir = require("lspconfig.util").find_git_ancestor,
      settings = {},
    },
  }
end

require("lspconfig").ruff.setup {
  on_init = M.on_init,
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

return M
