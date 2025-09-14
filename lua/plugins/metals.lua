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
  -- Explicitly tell Metals we support debugging via nvim-dap
  metals_config.init_options.debuggingProvider = true
  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    -- Show the modern test UI provided by Metals
    testUserInterface = "Test Explorer",
    -- scalafmt runs via Metals (ensure .scalafmt.conf in repos)
  }

  -- Optionally pin Metals server version via env var METALS_VERSION
  local pinned = vim.env.METALS_VERSION
  if pinned and pinned ~= "" then
    metals_config.settings.serverVersion = pinned
  end

  -- Set up DAP before Metals initializes so Doctor detects it
  pcall(metals.setup_dap)

  -- DAP-related per-buffer tweaks
  metals_config.on_attach = function(client, bufnr)

    -- Optional: format on save using Metals (requires .scalafmt.conf)
    local grp = vim.api.nvim_create_augroup("metals-format", { clear = false })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = grp,
      buffer = bufnr,
      callback = function()
        if vim.lsp.buf.format then
          vim.lsp.buf.format { async = false, bufnr = bufnr }
        end
      end,
      desc = "Format Scala/SBT via Metals on save",
    })
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
