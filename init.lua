-- Leader must be set before plugins/keys
-- Route Neovim cache into the repo to avoid sandboxed writes
do
  local cfg = vim.fn.stdpath('config')
  -- Redirect XDG dirs into the repo to avoid sandboxed writes
  local cache_root = cfg .. "/.cache"
  local state_root = cfg .. "/.state"
  -- Keep DATA at default so existing lazy plugins remain discoverable
  vim.env.XDG_CACHE_HOME = cache_root
  vim.env.XDG_STATE_HOME = state_root
  -- Do not override XDG_DATA_HOME here
  pcall(vim.fn.mkdir, cache_root .. "/nvim/luac", "p")
  pcall(vim.fn.mkdir, state_root .. "/nvim", "p")
  -- no data dir creation
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core
-- Built-in LSP will be configured via vim.lsp.config/enable in plugins.lsp

require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugins (Lazy bootstrap & setup lives here)
require("plugins")
