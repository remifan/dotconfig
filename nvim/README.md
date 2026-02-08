# nvim

Neovim config with [lazy.nvim](https://github.com/folke/lazy.nvim). Modular, fast, zero-config install.

## Structure

```
lua/
├── core/           # options, keymaps
├── plugins/        # lazy.nvim specs, one file per category
│   ├── editor      # treesitter, motions, surround, comments, multi-cursor
│   ├── lsp         # lspconfig + mason + lingua franca
│   ├── ui          # colorscheme, statusline, indent guides, trouble
│   ├── navigation  # telescope, mini.files, floating terminal
│   ├── git         # gitsigns
│   └── tools       # clipboard, registers, typst-preview, etc.
└── config/         # extended configs (lsp handlers, statusline, gitsigns)
```

## Language servers

Auto-installed via Mason:

| Server | Language |
|---|---|
| lua_ls | Lua |
| rust_analyzer | Rust |
| pyright | Python |
| verible | Verilog / SystemVerilog |
| tinymist | Typst |

[lf.nvim](https://github.com/remifan/lf.nvim) is loaded from a local path for Lingua Franca.

## Key bindings (non-obvious ones)

**LSP** (buffer-local on attach)
`gd` definition | `gr` references | `K` hover | `<space>ca` code action | `<space>rn` rename | `<space>f` format

**Navigation**
`<leader>ff` find files | `<leader>fg` live grep | `<leader>e` file explorer | `<leader>t` terminal

**Editing**
`s`/`S` leap | `gcc` comment | `Alt+j/k` move lines | `Ctrl+h/l` swap args | `ga` align

**Git**
`]c`/`[c` hunks | `<leader>hs` stage | `<leader>hr` reset | `<leader>hb` blame

**Typst**
`:TypstPreview` live preview | `:TypstPreviewToggle` toggle

## Adding plugins

Drop a spec in the appropriate file under `lua/plugins/`, or create a new one — lazy.nvim picks up anything imported in `init.lua`.
