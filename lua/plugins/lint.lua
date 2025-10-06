local M = {}

function M.setup()
  local lint = require("lint")
  -- Add a lightweight VHDL linter using GHDL analysis if available
  lint.linters.ghdl = lint.linters.ghdl or {
    cmd = "ghdl",
    stdin = false,
    args = function()
      local file = vim.api.nvim_buf_get_name(0)
      -- Analyze syntax/semantics; adjust standard if needed (93/02/08)
      return { "-s", "--std=08", file }
    end,
    ignore_exitcode = true,
    parser = function(output, bufnr)
      local diags = {}
      for line in output:gmatch("[^\n]+") do
        -- Example: /path/top.vhd:12:5: error: message
        local path, lnum, col, sev, msg = line:match("^(.-):(%d+):(%d+):%s*(%w+):%s*(.*)$")
        if path and lnum and col and msg then
          local severity = vim.diagnostic.severity.INFO
          local s = sev:lower()
          if s:find("error") then severity = vim.diagnostic.severity.ERROR
          elseif s:find("warn") then severity = vim.diagnostic.severity.WARN end
          table.insert(diags, {
            bufnr = bufnr,
            lnum = tonumber(lnum) - 1,
            col = tonumber(col) - 1,
            message = msg,
            severity = severity,
            source = "ghdl",
          })
        end
      end
      return diags
    end,
  }
  lint.linters_by_ft = {
    python = { "ruff" },
    -- if clang-tidy is installed, it will run; otherwise silently skip
    c = { "clangtidy" },
    cpp = { "clangtidy" },
    vhdl = (vim.fn.executable("ghdl") == 1) and { "ghdl" } or nil,
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
