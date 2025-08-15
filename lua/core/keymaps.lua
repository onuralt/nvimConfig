local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basics
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa!<cr>", opts)

-- Better movement between windows
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Clear search
map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", opts)
map("n", "<leader>bp", "<cmd>bprevious<cr>", opts)
map("n", "<leader>bd", "<cmd>bd<cr>", opts)

-- Neo-tree: toggle sidebar with Ctrl+n (loads plugin via :Neotree)
map("n", "<C-n>", "<cmd>Neotree left toggle reveal<cr>", opts)
map("n", "<leader>e", "<cmd>Neotree left toggle reveal<cr>", opts)
map("n", "<leader>o", "<cmd>Neotree left focus<cr>", opts)

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Which-key (show all)
map("n", "<leader>?", function()
  require("which-key").show { global = true }
end, opts)
