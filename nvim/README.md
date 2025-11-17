# Neovim Configuration

A well-organized, professional Neovim configuration with modular plugin management using [lazy.nvim](https://github.com/folke/lazy.nvim).

## Features

- **Modern Plugin Manager**: Uses lazy.nvim for fast, lazy-loading plugin management
- **Modular Structure**: Organized into logical categories for easy maintenance
- **LSP Support**: Full Language Server Protocol integration with mason.nvim
- **Git Integration**: Comprehensive git features with gitsigns
- **Fuzzy Finding**: Powerful file and text search with Telescope
- **Zero-Config Install**: Automatically installs lazy.nvim and all plugins on first run

## Quick Start

### Testing in Docker (Recommended)

Test the configuration in complete isolation without affecting your current setup:

```bash
# 1. Build the Docker image
./test-docker.sh build

# 2. Launch Neovim in Docker
./test-docker.sh nvim

# Or start with bash to explore
./test-docker.sh start
# Then inside container: nvim
```

The first launch will automatically install all plugins. Your config remains completely untouched!

### Fresh Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Launch Neovim:
   ```bash
   nvim
   ```

3. **That's it!** Lazy.nvim will automatically:
   - Install itself
   - Install all configured plugins
   - Set up language servers via Mason

4. After plugins install, restart Neovim for best results

### Testing Alongside Existing Config

Use `NVIM_APPNAME` to test without replacing your current config:

```bash
# One-time test
NVIM_APPNAME=dotconfig/nvim nvim

# Or create an alias
alias nvim-test='NVIM_APPNAME=dotconfig/nvim nvim'
nvim-test
```

### No Restart Needed

Unlike many Neovim configs, this setup is designed to work on first launch:
- lazy.nvim bootstraps automatically
- All plugins install in the background
- LSP servers are managed by Mason

## Directory Structure

```
nvim/
├── init.lua                          # Main entry point
├── lazy-lock.json                    # Plugin version lockfile
├── lua/
│   ├── core/                         # Core Neovim settings
│   │   ├── options.lua               # General vim options
│   │   └── keymaps.lua               # General keymaps
│   ├── plugins/                      # Plugin specifications (organized by category)
│   │   ├── editor.lua                # Text editing enhancements
│   │   ├── lsp.lua                   # LSP plugins
│   │   ├── ui.lua                    # UI and theme plugins
│   │   ├── git.lua                   # Git integration
│   │   ├── navigation.lua            # File/code navigation
│   │   └── tools.lua                 # Utility plugins
│   └── config/                       # Plugin-specific configurations
│       ├── lsp/
│       │   └── handlers.lua          # LSP keymaps and handlers
│       ├── git.lua                   # Gitsigns configuration
│       └── statusline.lua            # Express Line statusline config
└── README.md                         # This file
```

## Plugin Categories

### Editor Enhancements
- **nvim-treesitter** - Advanced syntax highlighting
- **leap.nvim** - Lightning-fast navigation
- **nvim-surround** - Surround text objects
- **move.nvim** - Move lines/blocks with Alt+hjkl
- **Comment.nvim** - Smart commenting
- **vim-visual-multi** - Multiple cursors
- And many more...

### LSP (Language Server Protocol)
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP server installer
- **mason-lspconfig** - Bridge between mason and lspconfig
- **fidget.nvim** - LSP progress UI

**Pre-configured Language Servers:**
- Lua (lua_ls)
- Rust (rust_analyzer)
- Python (pyright)
- Verilog/SystemVerilog (verible)

### UI
- **boo-colorscheme** - Dark color scheme
- **express_line.nvim** - Minimal statusline
- **indent-blankline** - Indent guides
- **trouble.nvim** - Diagnostic list
- **beacon.nvim** - Cursor highlight on jump

### Git Integration
- **gitsigns.nvim** - Git signs in gutter, hunk operations

### Navigation
- **telescope.nvim** - Fuzzy finder for files, buffers, grep
- **mini.files** - File explorer
- **FTerm.nvim** - Floating terminal

### Tools
- **nvim-osc52** - Copy over SSH/tmux
- **registers.nvim** - Register preview
- **vim-signature** - Mark visualization
- **guess-indent.nvim** - Auto-detect indentation

## Key Mappings

### General
- `<CR>` - Clear search highlights (normal mode)

### LSP (when attached)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Show references
- `K` - Hover documentation
- `<space>rn` - Rename symbol
- `<space>ca` - Code action
- `<space>f` - Format buffer
- `[d` / `]d` - Previous/next diagnostic

### Git (gitsigns)
- `]c` / `[c` - Next/previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>tb` - Toggle line blame

### Navigation
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>e` - File explorer (mini.files)
- `<leader>t` - Toggle floating terminal

### Trouble (Diagnostics)
- `<leader>xx` - Toggle trouble
- `<leader>xw` - Workspace diagnostics
- `<leader>xd` - Document diagnostics
- `gR` - LSP references in trouble

### Editor
- `gcc` - Toggle line comment
- `gc{motion}` - Comment motion
- `Alt+j/k` - Move line down/up
- `Alt+h/l` - Move character left/right
- `Ctrl+h/l` - Swap arguments left/right
- `ga` - Align text (visual mode)
- `s{char}{char}` - Leap to occurrence
- `W/B/E` - CamelCase word motions

## Customization

### Adding Plugins

1. Create or edit a file in `lua/plugins/` (choose appropriate category)
2. Add your plugin spec following lazy.nvim format:
   ```lua
   return {
     {
       "username/plugin-name",
       config = function()
         -- Plugin configuration here
       end,
     }
   }
   ```
3. Restart Neovim or run `:Lazy sync`

### Modifying Options

Edit `lua/core/options.lua` to change vim settings like indentation, UI, etc.

### Adding Keymaps

- General keymaps: `lua/core/keymaps.lua`
- Plugin-specific keymaps: In the plugin's config function

### Changing Theme

Edit `lua/plugins/ui.lua` and modify the colorscheme plugin configuration.

## Managing Plugins

### Lazy.nvim Commands

- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Install missing plugins and update
- `:Lazy clean` - Remove unused plugins
- `:Lazy update` - Update plugins
- `:Lazy log` - Show recent updates

### Mason Commands (LSP Servers)

- `:Mason` - Open Mason UI
- `:MasonInstall <server>` - Install a language server
- `:MasonUninstall <server>` - Uninstall a language server

## Troubleshooting

### Plugins Not Installing

1. Check internet connection
2. Run `:Lazy sync` manually
3. Check `:Lazy log` for errors

### LSP Not Working

1. Ensure language server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`

### Performance Issues

- Run `:Lazy profile` to see plugin load times
- Consider lazy-loading more plugins with `lazy = true` or `event = "VeryLazy"`

## Unused Files

Files with `.old` or `.unused` extensions are previous configurations kept for reference:
- `lsp.lua.old` - Old LSP config (now in `config/lsp/handlers.lua`)
- `gitconf.lua.old` - Old git config (now in `config/git.lua`)
- `elconf.lua.old` - Old statusline config (now in `config/statusline.lua`)
- `seconf.lua.unused` - SelectEase plugin config (plugin not currently installed)

You can safely delete these files once you've confirmed everything works.

## Credits

Built with:
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configs
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- And many other excellent Neovim plugins!
