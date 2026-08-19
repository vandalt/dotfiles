# Copilot Instructions

## Repository model

This is a [Chezmoi](https://www.chezmoi.io/) source directory for personal dotfiles. Source names determine their destination and behavior:

- `dot_` becomes a leading dot in the target path; `private_dot_config/...` deploys under `~/.config/...` with private permissions.
- `executable_` marks deployed scripts as executable, `symlink_` creates a symlink, and `.tmpl` files are Go templates evaluated with Chezmoi data.
- `.chezmoiignore` conditionally excludes targets by hostname. Preserve the existing OS and hostname template branches in files such as `dot_zshrc.tmpl`.

Do not expose or replace secret-backed templates with literal values. A full Chezmoi operation evaluates the Bitwarden-backed `dot_ads/dev_key.tmpl`; use a targeted command or `--skip-secrets` unless the local secret manager is available.

## Architecture

- Root-level files and `dot_zsh/` define shell, Git, tmux, IPython, and utility-script configuration. System-facing configurations live in `private_dot_config/`, including terminals, mail, Wayland compositors, status bar, input remappers, and user systemd units.
- `private_dot_config/nvim/` is a LazyVim configuration. `init.lua` loads `config.lazy` and built-ins; `lua/config/` sets global behavior, options, mappings, and bootstrap; `lua/plugins/` contains Lazy.nvim plugin-spec overrides grouped by concern; `lua/util/` holds shared Lua helpers.
- The root `lazyvim.json` and `lazy-lock.json` are the Neovim configuration and plugin-lock sources. `private_dot_config/nvim/symlink_lazyvim.json.tmpl` and `symlink_lazy-lock.json.tmpl` deploy them into `~/.config/nvim`; update the root files rather than the deployed targets. `mod/` contains alternate saved LazyVim/Neovim lock and extras snapshots.
- Sway and Hyprland are independent compositor configurations. Waybar’s `config`, `style.css`, `executable_mediaplayer.py`, and `power_menu.xml` are a coupled set; keep referenced filenames and module names aligned. The mail sync script is invoked by the `mbsync.service` systemd user unit and scheduled by `mbsync.timer`.

## Validation

There is no repository build or automated test suite. Validate the affected deployment target instead:

```sh
# Render one template without applying it
chezmoi execute-template < dot_zshrc.tmpl > /dev/null

# Preview a single deployed target
chezmoi apply --dry-run ~/.zshrc

# Preview all non-secret targets
chezmoi apply --dry-run --skip-secrets
```

For Neovim Lua, parse one changed file without loading the full configuration:

```sh
nvim --headless --clean -u NONE \
  '+lua assert(loadfile("private_dot_config/nvim/lua/plugins/util.lua"))' '+qa'
```

When the configured optional tools are installed, check the changed file with:

```sh
stylua --check private_dot_config/nvim/lua/plugins/util.lua
markdownlint-cli2 --config private_dot_config/markdownlint/config.markdownlint.yaml README.md
```

## Conventions

- Format Neovim Lua with `private_dot_config/nvim/stylua.toml`: two-space indentation and a 120-column width. Keep plugin changes as Lazy.nvim spec tables in the appropriate `lua/plugins/` module, using `opts`/`keys` overrides rather than editing LazyVim internals.
- `vim.g.autoformat` is intentionally disabled. Do not assume save-time formatting is active.
- Keep a file’s source prefix when moving or adding Chezmoi-managed files so destination name, permissions, symlink behavior, and template rendering remain correct.
- Treat lockfiles as intentional version pins: only update `lazy-lock.json` with a corresponding plugin/dependency change, and do not manually edit the symlinked target under `~/.config/nvim`.
