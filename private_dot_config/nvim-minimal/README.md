# My Neovim Configuration

My Neovim configuration.

- `init.lua` will install `mini.nvim` and setup `mini.deps`, which I use to manage my plugins.
- Files in the `plugin/` directory are loaded in alpha-numerical order.
  - Files starting with `0*_` configure core features (including all mappings, even for plugins)
  - Files starting with `1*_` configure plugins
- Files in `lua/` can be required elsewhere
- Files in `queries/` define extra treesitter queries

The `lua` directory contains lua code that will be used only if required elsewhere.

## References

I copied things from:

- [MiniMax](https://nvim-mini.org/MiniMax/)
- [LazyVim](https://www.lazyvim.org/)
- [vim-galore](https://github.com/mhinz/vim-galore)
