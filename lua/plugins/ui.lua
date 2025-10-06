local M = {}

function M.setup_colors()
  require("catppuccin").setup({
    flavour = "mocha",
    integrations = {
      treesitter = true,
      telescope = true,
      which_key = true,
      gitsigns = true,
      noice = true,
      notify = true,
      indent_blankline = { enabled = true },
    },
  })
  vim.cmd.colorscheme("catppuccin")
end

function M.setup_lualine()
  local has_git = pcall(vim.fn.system, { "git", "--version" })
  require("lualine").setup({
    options = {
      theme = "catppuccin",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      -- Show branch only if git executable is available (avoids jobstart/git calls)
      lualine_b = {
        { "branch", cond = function() return has_git end },
      },
      lualine_c = { { "filename", path = 1 } },
      -- Remove the diff component entirely to avoid spawning git jobs in sandboxed envs
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

function M.setup_bufferline()
  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      -- Use bufdelete to close buffers without killing the window/tab or Neovim
      close_command = function(n)
        local ok, bd = pcall(require, "bufdelete")
        if ok then bd.bufdelete(n, true) else vim.cmd("bdelete! " .. n) end
      end,
      right_mouse_command = function(n)
        local ok, bd = pcall(require, "bufdelete")
        if ok then bd.bufdelete(n, true) else vim.cmd("bdelete! " .. n) end
      end,
      middle_mouse_command = function(n)
        local ok, bd = pcall(require, "bufdelete")
        if ok then bd.bufdelete(n, true) else vim.cmd("bdelete! " .. n) end
      end,
      -- keep the global close icon default behavior
      -- show_close_icon = true,
      separator_style = "slant",
    },
  })
end

function M.setup_notify()
  local notify = require("notify")
  notify.setup({ stages = "fade", render = "compact", timeout = 2000 })
  vim.notify = notify
end

function M.setup_noice()
  require("noice").setup({
    lsp = {
      progress = { enabled = true },
      -- Enable Noice signature help (this clears your health warnings)
      signature = { enabled = true, auto_open = { enabled = true, trigger = true } },
      hover = { enabled = true },
      -- Make Noice handle LSP markdown rendering
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- safe even before cmp is installed
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  })
end

function M.setup_neotree()
  require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = { hide_dotfiles = false, hide_gitignored = true },
    },
    window = {
      position = "left",
      width = 32,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "toggle_node",
      },
    },
  })
end

return M
