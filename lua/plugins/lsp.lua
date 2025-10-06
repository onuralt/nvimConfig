local M = {}

function M.setup()
  -- Only enable Mason components if we can write to stdpath('state') (avoids log write errors in sandbox)
  local can_use_mason = false
  do
    local ok = pcall(function()
      local state = vim.fn.stdpath('state')
      local test = state .. "/nvim_mason_perm_test"
      local f = io.open(test, "w")
      if f then f:close(); os.remove(test) end
    end)
    can_use_mason = ok
  end

  local mason, mason_tool_installer
  if can_use_mason then
    mason = require "mason"
    mason_tool_installer = require "mason-tool-installer"

    -- Mason: use a single, explicit registry (no duplicate warning)
    mason.setup {
      registries = { "github:mason-org/mason-registry" },
    }

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
        "vhdl_ls",
        -- Formatters
        "stylua",
        "clang-format",
        "black",
        "isort",
        "prettierd",
        "shfmt",
        "verible",
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
  else
    vim.schedule(function()
      vim.notify("Skipping Mason setup (state dir not writable).", vim.log.levels.WARN)
    end)
  end

  -- nvim-cmp capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- Helper to setup a server (prefer built-in API; fallback to lspconfig)
  local function setup_server(name, opts)
    -- Prefer the new built-in API first to avoid deprecation warnings
    if vim.lsp and vim.lsp.config then
      if opts and next(opts) ~= nil then
        vim.lsp.config(name, opts)
      end
      return vim.lsp.enable(name)
    end
    -- Fallback for older Neovim: use nvim-lspconfig if available
    local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
    if ok_lspconfig and lspconfig[name] and type(lspconfig[name].setup) == "function" then
      return lspconfig[name].setup(opts)
    end
    -- Silently skip if no known API is available
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
  setup_server("lua_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })

  -- C/C++
  setup_server("clangd", {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  })

  -- Python
  setup_server("pyright", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        analysis = { typeCheckingMode = "basic", autoImportCompletions = true },
      },
    },
  })

  -- LaTeX
  setup_server("texlab", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      texlab = {
        build = { onSave = false },
        forwardSearch = { executable = "okular", args = { "--unique", "file:@pdf#src:@line@tex" } },
      },
    },
  })

  -- Grammar/spell: LTeX (start only if installed)
  if vim.fn.exepath "ltex-ls" ~= "" then
    setup_server("ltex", {
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
    })
  end

  -- Bash / JSON / YAML / Markdown / TOML / CMake
  setup_server("bashls", { capabilities = capabilities, on_attach = on_attach })
  setup_server("jsonls", { capabilities = capabilities, on_attach = on_attach })
  setup_server("yamlls", { capabilities = capabilities, on_attach = on_attach })
  setup_server("marksman", { capabilities = capabilities, on_attach = on_attach })
  setup_server("taplo", { capabilities = capabilities, on_attach = on_attach })
  setup_server("cmake", { capabilities = capabilities, on_attach = on_attach })

  -- VHDL (GHDL vhdl_ls). Start only if binary is available.
  do
    local has_exec = (vim.fn.executable("vhdl_ls") == 1)
    if has_exec then
      setup_server("vhdl_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
    else
      vim.schedule(function()
        vim.notify(
          "VHDL LSP (vhdl_ls) not found. Install system-wide and ensure it is on PATH.",
          vim.log.levels.WARN
        )
      end)
    end
  end
end

return M
