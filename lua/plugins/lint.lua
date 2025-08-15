local M = {}

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = {
    python = { "ruff" },
    -- if clang-tidy is installed, it will run; otherwise silently skip
    c = { "clangtidy" },
    cpp = { "clangtidy" },
  }

  local function try_lint()
    local ft = vim.bo.filetype
    if lint.linters_by_ft[ft] then
      lint.try_lint()
    end
  end

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function() try_lint() end,
  })
end

return M
