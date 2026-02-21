# My Neovim Configuration

My Neovim configuration.

## Structure

- `init.lua` will install `mini.nvim`
- Files in the `plugin/` directory are loaded in alphanumerical order.
  - Files starting with `0*_` configure core features (including all mappings, even for plugins)
  - Files starting with `1*_` configure plugins
- Files in `lua/` will be used only when required elsewhere
- Files in `queries/` define extra treesitter queries

## References

I copied things from:

- [MiniMax](https://nvim-mini.org/MiniMax/)
- [LazyVim](https://www.lazyvim.org/)
- [vim-galore](https://github.com/mhinz/vim-galore)
