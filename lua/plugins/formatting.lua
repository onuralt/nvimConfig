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
      local ft = vim.bo[bufnr].filetype
      -- For VHDL, only format if a formatter is available (no LSP fallback)
      if ft == "vhdl" then
        return { lsp_fallback = false, timeout_ms = 4000 }
      end
      return { lsp_fallback = true, timeout_ms = 2000 }
    end,

    formatters_by_ft = {
      lua = { "stylua" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      python = { "isort", "black" },
      -- HDL
      systemverilog = { "verible" },
      verilog = { "verible" },
      -- VHDL: use vhdl-style-guide (vsg) if a config is present
      vhdl = { "vsg" },

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
      -- Use verible-verilog-format for (System)Verilog via stdin
      verible = function()
        -- Allow user override via `vim.g.verible_format_args`
        local args = vim.g.verible_format_args or { "--indentation_spaces", "2" }
        return {
          command = "verible-verilog-format",
          stdin = true,
          prepend_args = args,
        }
      end,

      -- VHDL Style Guide formatter integration
      -- Prefer single-file fix to avoid requiring a project config.
      vsg = function(ctx)
        if vim.fn.executable("vsg") ~= 1 then return nil end
        local args = { "--fix" }
        -- If a config exists, include it
        local cfg = vim.fs.find({ "vsg.yml", "vsg.yaml", ".vsg.yml", ".vsg.yaml", "vhdl-style-guide.yml", "vhdl-style-guide.yaml" }, {
          upward = true, stop = vim.loop.os_homedir(), path = ctx.dirname,
        })[1]
        if cfg then
          table.insert(args, "-c")
          table.insert(args, cfg)
        end
        -- Format current file in-place
        table.insert(args, ctx.filename)
        return {
          command = "vsg",
          stdin = false,
          args = args,
        }
      end,
    },
  }
end

return M
