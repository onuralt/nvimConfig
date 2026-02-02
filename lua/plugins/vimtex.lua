local M = {}

function M.setup()
  -- Leaders (set these EARLY in your config)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Workaround: seed VimTeX OS detection cache to avoid empty `uname` result
  -- In restricted environments, `systemlist('uname')` may return empty,
  -- causing E684 on indexing. Pre-populate the capture cache with 'Linux'.
  pcall(function()
    local ok, res = pcall(vim.fn["vimtex#jobs#cached"], "uname")
    if not ok or type(res) ~= "table" or #res == 0 then
      vim.cmd([[call vimtex#cache#open('capture').set('uname', ['Linux'])]])
    end
  end)

  -- Avoid duplicate zathura plugin registration from env overrides.
  vim.env.ZATHURA_PLUGINS_PATH = ""

  -- Viewer: use simple Zathura backend to avoid window-ID/dbus issues
  vim.g.vimtex_view_method = "zathura_simple"
  vim.g.vimtex_view_automatic = 1
  -- Nuke old "general" settings to avoid conflicts
  vim.g.vimtex_view_general_viewer = nil
  vim.g.vimtex_view_general_options = nil

  -- Compiler: latexmk with build dir
  vim.g.vimtex_compiler_method = "latexmk"
  vim.g.vimtex_compiler_latexmk = {
    out_dir = "build",
    options = {
      "-pdf", -- switch to "-xelatex" if you move to XeLaTeX
      "-shell-escape",
      "-file-line-error",
      "-synctex=1",
      "-interaction=nonstopmode",
    },
  }

  -- Quickfix: open only on errors
  vim.g.vimtex_quickfix_open_on_warning = 0

  -- Fallback mappings in case maplocalleader was late
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
      vim.keymap.set("n", "\\ll", "<Plug>(vimtex-compile)", { buffer = true, silent = true })
      vim.keymap.set("n", "\\lv", "<Plug>(vimtex-view)", { buffer = true, silent = true })
    end,
  })
end

return M
