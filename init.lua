-- Leader must be set before plugins/keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugins (Lazy bootstrap & setup lives here)
require("plugins")
