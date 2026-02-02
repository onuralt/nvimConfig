local M = {}

function M.setup()
  require("conform").setup {
    format_on_save = function(bufnr)
      if vim.b[bufnr].disable_autoformat then
        return nil
      end
      -- Disable for big files
      local max = 500 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max then
        return nil
      end
      local ft = vim.bo[bufnr].filetype
      if ft == "tex" or ft == "plaintex" or ft == "bib" then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        for _, line in ipairs(lines) do
          if line:find("\\begin{svexample") or line:find("\\begin{circuitikz") or line:find("\\begin{tikzpicture") then
            return nil
          end
        end
        if ft == "tex" or ft == "plaintex" then
          return nil
        end
      end
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
      -- LaTeX via latexindent (single formatter runs two-pass wrap)
      tex = { "latexindent_wrap" },
      plaintex = { "latexindent_wrap" },
      bib = { "latexindent" },
      -- LaTeX fallback via texlab when available
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

      latexindent = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        -- Search upward for .latexindent.yaml
        local config_path = vim.fs.find('.latexindent.yaml', {
          upward = true,
          path = vim.fn.fnamemodify(bufname, ':h'),
          type = 'file'
        })[1]

        local args = { "-m" } -- Enable modifyLineBreaks settings
        if config_path then
          table.insert(args, "-l")
          table.insert(args, config_path)
        end
        table.insert(args, "-")

        return {
          command = "latexindent",
          stdin = true,
          args = args,
        }
      end,

      latexindent_wrap = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local config_path = vim.fs.find('.latexindent.yaml', {
          upward = true,
          path = vim.fn.fnamemodify(bufname, ':h'),
          type = 'file'
        })[1]

        local cfg = ""
        if config_path then
          cfg = "-l " .. vim.fn.shellescape(config_path)
        end
        local y = "modifyLineBreaks:textWrapOptions:blocksBeginWith:other:'\\\\\\\\gls'"
        local cmd = string.format(
          "latexindent -m %s - | latexindent -m %s -y %s -",
          cfg,
          cfg,
          vim.fn.shellescape(y)
        )

        return {
          command = "sh",
          stdin = true,
          args = { "-c", cmd },
        }
      end,
    },
  }
end

return M
