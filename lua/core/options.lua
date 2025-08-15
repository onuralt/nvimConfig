local o = vim.opt
local g = vim.g

-- General
o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 6
o.sidescrolloff = 8
o.splitright = true
o.splitbelow = true
o.updatetime = 200
o.timeoutlen = 400
o.incsearch = true
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.mouse = "a"
o.undofile = true
o.clipboard = "unnamedplus"
o.completeopt = { "menu", "menuone", "noselect" }

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Wayland clipboard (Hyprland): prefer wl-clipboard if available
local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end
if executable("wl-copy") and executable("wl-paste") then
  g.clipboard = {
    name = "wl-clipboard",
    copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
    paste = { ["+"] = "wl-paste -n", ["*"] = "wl-paste -n" },
    cache_enabled = 1,
  }
end

-- Reduce noise in cmdheight (Noice will handle UI)
o.cmdheight = 0

vim.cmd([[
  set shortmess+=c
]])

-- Providers
-- Use our dedicated Python host (PEP 668 friendly)
g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")

-- Optional: silence providers you don't use
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
-- Keep Node provider enabled (after npm install -g neovim it will be green)
