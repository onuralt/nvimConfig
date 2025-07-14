local M = {}

M.setup = function()
  vim.g.vimtex_view_method = 'zathura'
  vim.g.vimtex_compiler_method = 'latexmk'
end

return M
