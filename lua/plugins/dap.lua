local M = {}

function M.setup()
  -- Safe requires
  local function req(mod)
    local ok, m = pcall(require, mod)
    return ok and m or nil
  end

  local dap = req "dap"
  if not dap then
    vim.notify("nvim-dap not found", vim.log.levels.ERROR)
    return
  end

  -- mason-nvim-dap
  local mason_dap = req "mason-nvim-dap"
  if mason_dap then
    mason_dap.setup {
      ensure_installed = { "codelldb", "python" }, -- "python" installs debugpy
      automatic_installation = true, -- <-- correct option
      handlers = {}, -- use defaults
    }
  end

  -- Signs
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })

  -- Try loading nio (required by dap-ui) before dapui
  local nio_ok = pcall(require, "nio") -- module name from nvim-neotest/nvim-nio
  local dapui = nio_ok and req "dapui" or nil
  if not dapui then
    vim.notify(
      "nvim-dap-ui requires nvim-neotest/nvim-nio. Install it (Lazy dep) to enable the UI.",
      vim.log.levels.WARN
    )
  else
    dapui.setup()
    -- Auto open/close UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end

  -- Keymaps
  local map, opts = vim.keymap.set, { noremap = true, silent = true }
  map("n", "<F5>", function()
    dap.continue()
  end, opts)
  map("n", "<F10>", function()
    dap.step_over()
  end, opts)
  map("n", "<F11>", function()
    dap.step_into()
  end, opts)
  map("n", "<F12>", function()
    dap.step_out()
  end, opts)
  map("n", "<leader>db", function()
    dap.toggle_breakpoint()
  end, opts)
  map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
  end, opts)
  map("n", "<leader>dr", function()
    dap.repl.open()
  end, opts)
  if dapui then
    map("n", "<leader>du", function()
      dapui.toggle()
    end, opts)
  else
    map("n", "<leader>du", function()
      vim.notify("DAP UI unavailable (install nvim-neotest/nvim-nio).", vim.log.levels.WARN)
    end, opts)
  end
end

return M
