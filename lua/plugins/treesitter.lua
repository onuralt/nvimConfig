local M = {}

function M.setup()
  -- Optional: stabilize parser installs
  local ts_install = require "nvim-treesitter.install"
  ts_install.compilers = { "gcc", "clang" }
  ts_install.prefer_git = false

  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "lua",
      "python",
      "vim",
      "vimdoc",
      "query",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "latex",
      "bibtex",
      "html",
      "css",
      "javascript",
      "scala",
      "regex",
      "verilog", -- Verilog/SystemVerilog parser
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "latex" }, -- keep VimTeX highlights
    },
    indent = {
      enable = true,
      disable = { "latex" }, -- let VimTeX handle LaTeX indent
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    -- Enable auto-tagging for HTML/JSX/etc. (safe, no keymaps)
    autotag = { enable = true },
  }
end

return M
