-- Disable modelines globally (avoid E518 from "ex:" etc.)
vim.opt.modeline = false
vim.opt.modelines = 0
vim.opt.modelineexpr = false

local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd

local function buf_has_svexample(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:find("\\begin{svexample") then
      return true
    end
  end
  return false
end

local function format_svexample_blocks(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local blocks = {}
  local i = 1
  while i <= #lines do
    if lines[i]:find("\\begin{svexample") then
      local start = i + 1
      local j = start
      while j <= #lines do
        if lines[j]:find("\\end{svexample}") then
          table.insert(blocks, { start = start, finish = j - 1 })
          i = j
          break
        end
        j = j + 1
      end
    end
    i = i + 1
  end

  local args = vim.g.verible_format_args or { "--indentation_spaces", "2" }
  local cmd = { "verible-verilog-format" }
  for _, a in ipairs(args) do
    table.insert(cmd, a)
  end

  for idx = #blocks, 1, -1 do
    local block = blocks[idx]
    if block.finish >= block.start then
      local code = vim.api.nvim_buf_get_lines(bufnr, block.start - 1, block.finish, false)
      local output = vim.fn.system(cmd, table.concat(code, "\n"))
      if vim.v.shell_error == 0 then
        local formatted = vim.split(output, "\n", { plain = true })
        if formatted[#formatted] == "" then
          table.remove(formatted, #formatted)
        end
        -- Collapse consecutive empty lines inside svexample blocks
        local compact = {}
        local prev_blank = false
        for _, line in ipairs(formatted) do
          local is_blank = line:match("^%s*$") ~= nil
          if not is_blank or not prev_blank then
            table.insert(compact, line)
          end
          prev_blank = is_blank
        end
        formatted = compact
        vim.api.nvim_buf_set_lines(bufnr, block.start - 1, block.finish, false, formatted)
      end
    end
  end
end

-- Highlight on yank
aug("YankHighlight", { clear = true })
auc("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})

-- Restore cursor position
auc("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- LaTeX formatting defaults
auc("FileType", {
  pattern = { "tex", "plaintex", "bib" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t")
  end,
})

-- Keep Code/*.tex snippets verbatim (avoid format-on-save)
auc({ "BufRead", "BufNewFile" }, {
  pattern = "*/Code/*.tex",
  callback = function()
    vim.b.disable_autoformat = true
  end,
})

-- Hard-wrap TeX on save using Vim's formatter (gq).
auc("BufWritePre", {
  pattern = { "*.tex" },
  callback = function()
    if vim.b.disable_autoformat then return end
    if buf_has_svexample(0) then
      format_svexample_blocks(0)
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd("silent keepjumps normal! gggqG")
    vim.fn.winrestview(view)
  end,
})

-- Let Conform handle TeX/Bib formatting on save (avoid double-formatting).

-- Manual format command (uses Conform)
vim.api.nvim_create_user_command("Format", function()
  require("conform").format { async = true }
end, {})

-- Allow lowercase :format as an alias.
vim.cmd("cnoreabbrev <expr> format (getcmdtype() == ':' && getcmdline() ==# 'format') ? 'Format' : 'format'")
