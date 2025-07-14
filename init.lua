require "core"

-- Wayland clipboard integration
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

-- Set conceallevel to 0 globally
vim.opt.conceallevel = 0

-- Enable conceal only in LaTeX files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

-- Auto-open PDF files in Zathura
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.pdf",
  callback = function()
    vim.fn.jobstart({ "zathura", vim.fn.expand("%:p") }, { detach = true })
    vim.cmd("bdelete!") -- Close the buffer to avoid showing binary garbage
  end,
})

-- Load optional custom init if it exists
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]
if custom_init_path then
  dofile(custom_init_path)
end

-- Load key mappings
require("core.utils").load_mappings()

-- Bootstrap lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

-- Load plugins and base46 theme
dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
