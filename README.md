# Neovim Configuration

Personal Neovim setup powered by [lazy.nvim](https://github.com/folke/lazy.nvim). It provides a modern development environment for everyday coding along with focused support for Scala/Chisel and LaTeX workflows.

## Features

- Catppuccin colorscheme with lualine, bufferline, noice and notify for a polished UI
- Neo-tree file explorer
- Telescope (with fzf extension) for fuzzy finding
- Treesitter-based syntax highlighting
- which-key, Comment.nvim, autopairs, gitsigns and indent-blankline for quality of life
- LSP management via mason and nvim-lspconfig
- Autocompletion through nvim-cmp and LuaSnip
- Formatting with conform.nvim and linting with nvim-lint
- Debugging using nvim-dap, nvim-dap-ui and mason-nvim-dap
- Scala and Chisel development via nvim-metals
- LaTeX editing with vimtex
- Diagnostics UI through trouble.nvim

## Prerequisites

- Neovim 0.9+
- git
- Optional:
  - `zathura`, `latexmk` and `texlab` for LaTeX features
  - JDK and [Metals](https://scalameta.org/metals/) for Scala/Chisel

Install on Debian/Ubuntu:

```bash
sudo apt install neovim git zathura openjdk-17-jdk texlive-full
```

On Arch:

```bash
sudo pacman -S neovim git zathura jdk-openjdk texlive-most
```

## Installation

Clone this repository to `~/.config/nvim`:

```bash
git clone <repo-url> ~/.config/nvim
```

Open Neovim and plugins will be installed automatically on first launch.

### Customization

- Plugins are declared in `lua/plugins/init.lua`
- Options, keymaps and autocmds live under `lua/core`
- Create files under `lua/custom` to override or extend the defaults

## Key Mappings

Most mappings use the `<leader>` key (space). Useful ones include:

| Mapping       | Action                         |
| ------------- | ------------------------------ |
| `<leader> e`  | Toggle file tree (neo-tree)    |
| `<leader> ff` | Find files (telescope)         |
| `<leader> fw` | Live grep                      |
| `<leader> h`  | Open horizontal terminal       |
| `<leader> v`  | Open vertical terminal         |
| `\ll`         | Compile current TeX document   |
| `gD`/`gd`     | Go to declaration/definition   |

Run `:WhichKey` or press `<leader>` to view available shortcuts.

## Key Mappings (Complete)

Leader is space (`<leader> = <space>`). The following are defined by this config and its plugin setups.

### Global
- `<leader>w`: Save file
- `<leader>q`: Quit window
- `<leader>Q`: Quit all (force)
- `<esc>`: Clear search highlight

### Window Navigation
- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>`: Move to left/down/up/right window

### Buffers
- `<leader>bn`: Next buffer
- `<leader>bp`: Previous buffer
- `<leader>bd`: Delete buffer

### File Explorer (Neo-tree)
- `<C-n>`: Toggle tree (left) and reveal current file
- `<leader>e`: Toggle tree (left) and reveal current file
- `<leader>o`: Focus tree
- In Neo-tree window:
  - `l`: Open
  - `h`: Close node
  - `<space>`: Toggle node

### Telescope
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Buffers picker
- `<leader>fh`: Help tags
- Inside Telescope prompt (insert mode):
  - `<C-j>` / `<C-k>`: Next/previous selection
  - `<C-q>`: Send selection to quickfix list

### which-key
- `<leader>?`: Show available mappings

### LSP (buffer-local when a server attaches)
- `gd`: Go to definitions (Telescope)
- `gr`: References (Telescope)
- `gi`: Implementations (Telescope)
- `gD`: Go to declaration
- `K`: Hover documentation
- `<leader>rn`: Rename symbol
- `<leader>ca`: Code action
- `[d` / `]d`: Previous/next diagnostic
- `<leader>f` (normal/visual): Format via conform.nvim
- Note: In LSP buffers, `<leader>e` opens diagnostic float (this is buffer-local and may shadow the global Neo-tree `<leader>e`).

### Debugging (nvim-dap)
- `<F5>`: Continue/start
- `<F10>`: Step over
- `<F11>`: Step into
- `<F12>`: Step out
- `<leader>db`: Toggle breakpoint
- `<leader>dB`: Conditional breakpoint
- `<leader>dr`: Open REPL
- `<leader>du`: Toggle DAP UI

### Treesitter
- Incremental selection:
  - `gnn`: Init selection
  - `grn`: Node incremental
  - `grc`: Scope incremental
  - `grm`: Node decremental

### Completion (nvim-cmp)
- Insert mode:
  - `<C-b>` / `<C-f>`: Scroll docs up/down
  - `<C-Space>`: Trigger completion
  - `<CR>`: Confirm selection (selects first by default)
  - `<Tab>` / `<S-Tab>`: Next/previous item, or jump in snippet
- Command-line completion:
  - `/`: Buffer-based completion in search
  - `:`: Path and command completion

### LaTeX (VimTeX, buffer-local for `tex`)
- `\\ll`: Compile
- `\\lv`: View (Zathura)

## Verilog / SystemVerilog

- Syntax: Tree-sitter parser `verilog` is enabled. Install/update with `:TSUpdate verilog`.
- Formatting: Conform uses `verible-verilog-format` (formats on save). Default flags: `--indentation_spaces 2`.
- Tools: Install the formatter via Mason (`:Mason` → install "verible" or `:MasonToolsInstall verible`).
- Override flags (optional):

```lua
-- e.g. in init.lua or lua/custom/*.lua
vim.g.verible_format_args = { "--indentation_spaces", "2", "--column_limit", "120" }
```

- Verify:
  - `:ConformInfo` in a `.sv`/`.v` buffer should list `verible`.
  - `:TSModuleInfo` should show the `verilog` parser active.

## Troubleshooting

- Ensure an internet connection for first-time plugin installation
- Use `:Mason` to install required LSP/DAP/formatter tools
- Update plugins with `:Lazy sync` if something misbehaves

## License

MIT — see [LICENSE](LICENSE).
