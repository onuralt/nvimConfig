local M = {}

function M.setup()
  require("conform").setup {
    format_on_save = function(bufnr)
      -- Disable for big files
      local max = 500 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max then
        return nil
      end
      return { lsp_fallback = true, timeout_ms = 2000 }
    end,

    formatters_by_ft = {
      lua = { "stylua" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      python = { "isort", "black" },

      -- Web: prefer prettierd only (no warning about missing 'prettier')
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      ["markdown.mdx"] = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },

      sh = { "shfmt" },
      -- LaTeX via texlab/latexindent through LSP fallback
      -- Scala/Chisel via Metals (scalafmt) through LSP fallback
    },

    -- Optional per-formatter tweaks
    formatters = {
      shfmt = { prepend_args = { "-i", "2", "-bn", "-ci" } },
    },
  }
end

return M
