# nvim

Neovim 0.12 config using built-in `vim.pack`, LSP completion, and undotree. Modular, fast, zero-config install.

## Structure

```
init.lua            # vim.pack plugin declarations + pre-load settings
lua/
├── core/           # options, keymaps
└── config/         # extended configs (lsp handlers, statusline, gitsigns)
after/plugin/       # plugin configurations (loaded after plugins)
├── colorscheme     # boo colorscheme
├── editor          # treesitter, motions, surround, comments, multi-cursor
├── lsp             # mason + mason-lspconfig + lingua franca + server picker
├── ui              # statusline, indent guides, trouble, stay-centered
├── navigation      # telescope, yazi, floating terminal
├── git             # gitsigns, lazygit
└── tools           # clipboard, registers, typst-preview, etc.
```

## Fresh install

1. Launch `nvim` — `vim.pack` prompts to install all plugins (`:w` to confirm)
2. LSP server picker appears — `<Space>` to toggle, `<CR>` to confirm
3. Neovim auto-restarts; Mason finishes installing LSP servers
4. Open a file — treesitter parser prompt appears for each new filetype

Re-run the LSP picker anytime with `:LspServerSelect`.

## Plugin management

```vim
:lua vim.pack.update()                          " Update all plugins
:lua vim.pack.update(nil, {target='lockfile'})  " Sync to lockfile
:lua vim.pack.get()                             " List installed plugins
:checkhealth vim.pack                           " Health check
```

## Language servers

Selected interactively via `:LspServerSelect`. Available servers:

| Server | Language | Provider |
|---|---|---|
| lua_ls | Lua | Mason |
| rust_analyzer | Rust | Mason |
| pyright | Python | Mason |
| verible | Verilog / SystemVerilog | Mason |
| tinymist | Typst | Mason |
| lf | Lingua Franca | [lf.nvim](https://github.com/remifan/lf.nvim) |

## Key bindings (non-obvious ones)

**LSP** (buffer-local on attach)
`gd` definition | `gr` references | `K` hover | `<space>ca` code action | `<space>rn` rename | `<space>f` format

**Navigation**
`<leader>ff` find files | `<leader>fg` live grep | `<leader>e` yazi file manager | `<leader>yc` yazi (cwd) | `<leader>t` terminal

**Editing**
`s`/`S` leap | `gcc` comment | `Alt+j/k` move lines | `Ctrl+h/l` swap args | `ga` align | `<leader>u` undotree

**Git**
`]c`/`[c` hunks | `<leader>hs` stage | `<leader>hr` reset | `<leader>hb` blame | `<leader>lg` lazygit

**Typst**
`:TypstPreview` live preview | `:TypstPreviewToggle` toggle

## Adding plugins

Add the URL to the `vim.pack.add()` list in `init.lua`, then create a config file in `after/plugin/`.
