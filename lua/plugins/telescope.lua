local M = {}

function M.setup()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-q>"] = "send_to_qflist",
        },
      },
      layout_strategy = "flex",
      layout_config = { width = 0.95, height = 0.90 },
      path_display = { "smart" },
    },
    pickers = {
      find_files = { hidden = true },
    },
  })
end

return M

