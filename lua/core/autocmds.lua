-- Disable modelines globally (avoid E518 from "ex:" etc.)
vim.opt.modeline = false
vim.opt.modelines = 0
vim.opt.modelineexpr = false

local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd

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
