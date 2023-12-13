# Ayman's (Neo)Vim config

Based on [LazyVim](https://github.com/LazyVim/LazyVim).

## Local Configuration

This distribution supports some custom options defined in the Vim global
namespace, this includes:

- `blameline` - show/hide current line blame (default: false)
- `smart_relativenumber` - toggle relativenumber automatically on normal/insert
  mode (default: true)

You can overwrite editor options by placing them in
[./lua/config/local.lua](./lua/config/local.lua). For example, to disable
the `relativenumber` option and `smart_relativenumber`

```lua
vim.o.relativenumber = false
vim.g.smart_relativenumber = false
```
