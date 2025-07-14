local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  b.formatting.black,
}

if vim.fn.executable "ruff" == 1 and b.diagnostics.ruff then
  table.insert(sources, b.diagnostics.ruff)
end

return {
  sources = sources,
}
