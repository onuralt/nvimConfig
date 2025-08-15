local M = {}

function M.setup()
  local metals = require("metals")
  local metals_config = metals.bare_config()

  -- nvim-cmp capabilities
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    metals_config.capabilities = cmp_nvim_lsp.default_capabilities()
  end

  metals_config.init_options.statusBarProvider = "on"
  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    -- scalafmt runs via Metals (ensure .scalafmt.conf in repos)
  }

  -- DAP integration
  metals_config.on_attach = function(client, bufnr)
    -- Reuse LSP keymaps from general on_attach via commands if desired.
    -- Metals provides its own commands for test/debug.
  end
  metals_config.tvp = { icons = { enabled = true } }

  -- Auto-start Metals in Scala/Chisel projects
  local aug = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = { "scala", "sbt" },
    callback = function()
      metals.initialize_or_attach(metals_config)
    end,
  })
end

return M
