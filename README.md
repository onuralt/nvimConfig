# Neovim Configuration

This repository contains my personal Neovim setup built on top of the NvChad framework.  It provides a streamlined environment with batteries included for day‑to‑day coding and LaTeX editing.

## Features

- **Lazy loading plugins** for fast start‑up
- **VimTeX** integration with Zathura preview
- **Scala and Chisel** development via the Metals language server
- Preconfigured **Telescope**, **tree view**, integrated terminal and more
- Common key mappings available through **which‑key**


## Prerequisites

- **Neovim** 0.9 or newer
- **git** for cloning this configuration
- **zathura** for PDF preview with VimTeX
- **JDK** and [Metals](https://scalameta.org/metals/) for Scala/Chisel
- **latexmk** and **texlab** for LaTeX language features

On Debian/Ubuntu install everything via:

```bash
sudo apt install neovim git zathura openjdk-17-jdk texlive-full
```

On Arch based systems:

```bash
sudo pacman -S neovim git zathura jdk-openjdk texlive-most
```

## Installation

1. Clone this repository to `~/.config/nvim`:

   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
2. Start Neovim; plugins will be installed automatically on first launch.

### Customization

Plugins are listed in `lua/plugins/init.lua`.  Disable or add entries there to
tailor the setup.  Key mappings live in `lua/core/mappings.lua`.  You can also
create files under `lua/custom` to override or extend any part of the
configuration without touching the defaults.

## Usage

- **File explorer**: `<leader> e` to toggle *nvim-tree*
- **Fuzzy finder**: `<leader> f f` to search files with *telescope*
- **Terminal**: `<leader> h`/`<leader> v` for horizontal/vertical terminals
- **Which‑key**: `<leader>` to view available shortcuts
- **Compile LaTeX**: `\ll` inside a `.tex` buffer
- **Start Metals**: `:MetalsInstall` then `:MetalsInitialize`

## Hotkeys

Most keybindings use the `<leader>` key (space).  Useful mappings include:

| Mapping        | Action                           |
| -------------- | -------------------------------- |
| `<leader> e`   | Toggle file tree                 |
| `<leader> ff`  | Find files                       |
| `<leader> fw`  | Live grep                        |
| `<leader> h`   | Open horizontal terminal         |
| `<leader> v`   | Open vertical terminal           |
| `\ll`          | Compile current TeX document     |
| `gD`/`gd`      | Go to declaration/definition (LSP) |

Refer to `NvCheatsheet` (`<leader> ch`) for a full list.

## Plugin List

| Plugin | Purpose |
| ------ | ------- |
| NvChad/base46 | Theme and highlighting |
| NvChad/ui | UI components |
| nvim-lua/plenary.nvim | Lua utility functions |
| nvim-tree/nvim-tree.lua | File explorer |
| nvim-telescope/telescope.nvim | Fuzzy finding |
| nvim-treesitter/nvim-treesitter | Syntax highlighting |
| nvim-tree/nvim-web-devicons | File icons |
| lewis6991/gitsigns.nvim | Git integration |
| lervag/vimtex | LaTeX tools |
| scalameta/nvim-metals | Scala/Chisel LSP |
| williamboman/mason.nvim | LSP/DAP installer |
| neovim/nvim-lspconfig | LSP configuration |
| hrsh7th/nvim-cmp | Completion engine |
| L3MON4D3/LuaSnip | Snippet engine |
| numToStr/Comment.nvim | Comment toggling |
| zbirenbaum/nvterm | Integrated terminal |

See `lua/plugins/init.lua` for the complete list and options.

## Troubleshooting

- **Plugin install fails** – ensure you have an internet connection and the
  necessary build tools for any plugins with native code.
- **LSP servers not starting** – run `:Mason` to check whether required servers
  are installed and install missing ones with `MasonInstall`.
- **Performance issues** – try updating plugins with `:Lazy sync` and keep
  Neovim up to date.

## License

This configuration is released under the [MIT](LICENSE) license.

