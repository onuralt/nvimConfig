# Neovim Configuration

This repository contains my personal Neovim setup built on top of the NvChad framework.  It provides a streamlined environment with batteries included for day‑to‑day coding and LaTeX editing.

## Features

- **Lazy loading plugins** for fast start‑up
- **VimTeX** integration with Zathura preview
- **Scala and Chisel** development via the Metals language server
- Preconfigured **Telescope**, **tree view**, integrated terminal and more
- Common key mappings available through **which‑key**

## Installation

1. Install Neovim 0.9+ and git.
2. Clone this repository to `~/.config/nvim`:

   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
3. Start Neovim and the required plugins will be installed automatically.

### Additional dependencies

- `zathura` for PDF preview with VimTeX
- JDK and [Metals](https://scalameta.org/metals/) for Scala/Chisel
- `latexmk` and `texlab` for LaTeX language features

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

