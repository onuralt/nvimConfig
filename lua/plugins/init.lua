-- Bootstrap lazy.nvim (unchanged)
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- ---- compat shim: accept old table-form vim.validate without deprecation noise
do
  local old_validate = vim.validate
  local alias = { s = "string", n = "number", t = "table", f = "function", b = "boolean" }

  local function is_callable(x)
    if type(x) == "function" then
      return true
    end
    if type(x) == "table" then
      local mt = getmetatable(x)
      return mt and type(mt.__call) == "function"
    end
    return false
  end

  vim.validate = function(a, b, c, d)
    -- Old API: vim.validate{ key = { val, predicate, optional?, msg? }, ... }
    if type(a) == "table" and b == nil then
      for name, spec in pairs(a) do
        local val, pred, optional, msg = spec[1], spec[2], spec[3], spec[4]
        if not (optional and val == nil) then
          local ok = true
          local predt = type(pred)
          if predt == "string" then
            local expected = alias[pred] or pred
            if expected == "callable" then
              ok = is_callable(val)
            elseif expected ~= "any" then
              ok = (type(val) == expected)
            end
          elseif predt == "function" then
            local ok_fun, res = pcall(pred, val)
            ok = ok_fun and res ~= false
          elseif predt == "table" then
            ok = false
            for _, p in ipairs(pred) do
              local expected = alias[p] or p
              if expected == "callable" and is_callable(val) then
                ok = true
                break
              end
              if expected == "any" or type(val) == expected then
                ok = true
                break
              end
            end
          end
          if not ok then
            error(msg or ("invalid value for " .. name))
          end
        end
      end
      return true
    end
    -- New API path (positional form)
    return old_validate(a, b, c, d)
  end
end

require("lazy").setup({
  -- Core libs
  { "nvim-lua/plenary.nvim", lazy = true },

  -- UI / Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("plugins.ui").setup_colors()
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.ui").setup_lualine()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.ui").setup_bufferline()
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("plugins.ui").setup_noice()
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("plugins.ui").setup_notify()
    end,
  },

  -- Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    config = function()
      require("plugins.ui").setup_neotree()
    end,
  },

  -- Telescope + fzf
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.telescope").setup()
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable "make" == 1
    end,
    config = function()
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins.treesitter").setup()
    end,
  },

  -- QoL
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  },
  { "numToStr/Comment.nvim", config = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  {
    "lewis6991/gitsigns.nvim",
    enabled = false, -- disable in this environment to avoid git spawn errors
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  -- Safe buffer deletion to avoid closing windows/tabs on close actions
  { "famiu/bufdelete.nvim", lazy = true },

  ---------------------------------------------------------------------------
  -- STEP 2: Dev features
  ---------------------------------------------------------------------------

  -- LSP management
  { "williamboman/mason.nvim", config = true },
  -- Drop mason-lspconfig to avoid legacy lspconfig framework usage
  { "WhoIsSethDaniel/mason-tool-installer.nvim", dependencies = { "mason.nvim" } },
  {
    "neovim/nvim-lspconfig",
    -- No dependence on mason-lspconfig; we use vim.lsp.config
    config = function()
      require("plugins.lsp").setup()
    end,
  },
  { "folke/neodev.nvim", opts = {} }, -- Lua dev for Neovim

  -- Completion + snippets
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp").setup()
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- Formatting & linting
  {
    "stevearc/conform.nvim",
    config = function()
      require("plugins.formatting").setup()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("plugins.lint").setup()
    end,
  },

  -- DAP (Debugging)
  { "mfussenegger/nvim-dap" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- REQUIRED by nvim-dap-ui
    },
    config = function()
      require("plugins.dap").setup() -- your M.setup() from lua/plugins/dap.lua
    end,
  },

  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" }, config = true },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "codelldb", "python" }, -- "python" pulls debugpy
      automatic_installation = true,
      handlers = {},
    },
  },

  -- Scala / Chisel
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    config = function()
      require("plugins.metals").setup()
    end,
  },

  -- LaTeX
  {
    "lervag/vimtex",
    config = function()
      require("plugins.vimtex").setup()
    end,
  },

  -- Diagnostics UI
  { "folke/trouble.nvim", opts = { use_diagnostic_signs = true } },

  -- Code outline (symbols sidebar powered by LSP)
  { "stevearc/aerial.nvim", opts = {} },

  -- Better quickfix window (jumping through compiler/LSP errors)
  { "kevinhwang91/nvim-bqf", ft = "qf" },

  ---------------------------------------------------------------------------
  -- FEDA extras (added without changing existing behavior or keymaps)
  ---------------------------------------------------------------------------
  -- FZF-powered picker (alongside Telescope); no keymaps
  { "ibhagwan/fzf-lua", cmd = "FzfLua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Flash: jump/motion enhancements; no default mappings configured
  { "folke/flash.nvim", event = "VeryLazy", opts = {} },

  -- Project-wide find/replace; exposes :GrugFar
  { "MagicDuck/grug-far.nvim", cmd = "GrugFar", opts = {} },

  -- TODO/FIXME highlighting + commands; no keymaps
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

  -- Additional editing utilities from 'mini.'
  -- NOTE: mini.pairs disabled to avoid conflict with nvim-autopairs
  { "echasnovski/mini.pairs", enabled = false },
  -- Disable default surround mappings to avoid altering keybinds
  {
    "echasnovski/mini.surround",
    version = false,
    opts = { mappings = { add = "", delete = "", replace = "", find = "", find_left = "", highlight = "", update_n_lines = "", suffix_last = "", suffix_next = "" } },
  },
  -- Textobjects improvements (no keymaps defined by default)
  { "echasnovski/mini.ai", version = false, config = function() require("mini.ai").setup() end },

  -- Treesitter extras
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },

  -- Sessions and buffer scoping (no keymaps)
  { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
  { "tiagovla/scope.nvim", opts = {} },

  -- Tmux pane navigation integration; no keymaps set
  { "alexghergh/nvim-tmux-navigation", opts = { disable_when_zoomed = true } },

  -- Tree-sitter-powered commenting; add but keep disabled to avoid replacing Comment.nvim
  { "folke/ts-comments.nvim", enabled = false },

  -- Alternative completion engine; add but keep disabled to avoid conflicts with nvim-cmp
  { "saghen/blink.cmp", enabled = false },
}, {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})
