# Repository Guidelines

This repository contains a Lua‑based Neovim configuration managed by lazy.nvim. Use this guide to contribute safely and consistently.

## Project Structure & Module Organization
- `init.lua`: entry point; sets XDG cache/state into repo and loads core + plugins.
- `lua/core/`: editor essentials (`options.lua`, `keymaps.lua`, `autocmds.lua`).
- `lua/plugins/`: plugin specs and configs (lazy.nvim) with one file per area (e.g., `lsp.lua`, `telescope.lua`). Specs live in `lua/plugins/init.lua`.
- `.stylua.toml`: Lua formatting rules. `.github/`: issue/PR templates. Logs and caches are git‑ignored.

## Build, Test, and Development Commands
- Run locally: `nvim` (first launch bootstraps lazy.nvim).
- Sync plugins: `:Lazy sync` or headless `nvim --headless '+Lazy! sync' '+qa'`.
- Update Treesitter parsers: `:TSUpdate`.
- Health check: `nvim --headless '+checkhealth | tee health.txt' '+qa'`.
- Optional native builds (fzf): ensure `make` is available; lazy.nvim will build when needed.

## Coding Style & Naming Conventions
- Lua, 2‑space indentation; expand tabs. Keep modules small and focused.
- File naming: snake_case files under `lua/core` and `lua/plugins` (e.g., `formatting.lua`).
- Module pattern: expose a table `M` with `M.setup()` when appropriate; keep side effects in `setup()`.
- Format before committing: `stylua .` (configured via `.stylua.toml`).

## Testing Guidelines
- Aim for a clean startup: `nvim --clean -u init.lua` to validate load order.
- Verify plugin state: `:Lazy` shows pending tasks; fix errors before submitting.
- Run `:checkhealth` and ensure major providers (Python host, Node) report OK.

## Commit & Pull Request Guidelines
- Commits: prefer Conventional Commits (`feat:`, `fix:`, `chore:`). Keep changes scoped.
- PRs: include a clear description, rationale, and screenshots/gifs if UI is affected (statusline, colors, UI plugins).
- Link related issues; note required follow‑ups (e.g., new keymaps in README if applicable).
- Do not commit caches/logs; `lazy-lock.json` and `.cache/`, `.state/` are ignored by `.gitignore`.

## Security & Configuration Tips
- Python host: edit `lua/core/options.lua` (`g.python3_host_prog`) if your path differs.
- Wayland: clipboard integration uses `wl-copy/wl-paste` when available.
- Some plugins (e.g., `gitsigns`) may be disabled by default to avoid CI/sandbox issues—enable locally as needed.
