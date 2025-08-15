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

## Troubleshooting

- Ensure an internet connection for first-time plugin installation
- Use `:Mason` to install required LSP/DAP/formatter tools
- Update plugins with `:Lazy sync` if something misbehaves

## License

MIT — see [LICENSE](LICENSE).

