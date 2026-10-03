# Repository Guidelines

## Project Structure and Module Organization

`init.lua` loads the core configuration and starts Lazy.nvim. Put startup behavior in `lua/core/`, shared helpers in `lua/utils.lua`, and plugin specifications in `lua/plugins/`. Group language-specific plugins under `lua/plugins/languages/` and LSP modules under `lua/plugins/lsp/`. Use `after/lsp/` for server-specific settings and `after/ftplugin/` for filetype overrides. The `spell/` directory contains the custom English word list. Lazy.nvim generates `lazy-lock.json`; do not edit dependency hashes by hand.

## Build, Test, and Development Commands

This repository has no compile step. Use these commands from the repository root:

```sh
nvim
nvim --headless '+qa'
nvim --headless '+Lazy! sync' '+qa'
stylua --check .
stylua .
```

The first command starts the configuration for manual checks. The second command detects startup errors without opening the interface. The third command installs and synchronizes plugins. Review every resulting `lazy-lock.json` change. The final commands check and apply Lua formatting. The current StyLua configuration can require a compatible StyLua release.

## Coding Style and Naming Conventions

Follow `.stylua.toml`: use two spaces, Unix line endings, double quotes, and a 120-column limit. Name Lua modules and files with lowercase words and underscores. Keep plugin files focused on one plugin or one feature area. Use descriptive names for keymaps and autocommand groups. Keep global names to a minimum and declare valid Neovim globals in `.luarc.json` when required.

## Testing Guidelines

The repository has no automated test suite or coverage target. Run the headless startup check after each change. Then open Neovim and exercise each affected keymap, command, filetype, LSP server, or plugin. For LSP changes, open a representative file and inspect `:checkhealth vim.lsp`.

## Commit and Pull Request Guidelines

Use Conventional Commit messages such as `feat(lsp): add server settings`, `fix(core): correct startup option`, or `build: update plugins`. Keep each commit focused. A pull request must explain the changed behavior, name the validation steps, and call out lockfile changes. Add screenshots only when a visible interface change needs comparison.
