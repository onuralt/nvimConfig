local M = {}

function M.setup()
  -- Leaders (set these EARLY in your config)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Viewer: use VimTeX's Okular backend (no "general" wrapper)
  vim.g.vimtex_view_method = "zathura"
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
