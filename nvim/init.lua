-- ============================================================================
-- Neovim Configuration Entry Point
-- ============================================================================
-- This is the main init.lua that bootstraps the entire Neovim configuration.
-- It loads core settings, sets up the plugin manager (lazy.nvim), and loads
-- all plugins.
--
-- Configuration Structure:
--   lua/core/          - Core Neovim settings (options, keymaps)
--   lua/plugins/       - Plugin specifications organized by category
--   lua/config/        - Plugin-specific configurations

-- ============================================================================
-- Leader Key Setup
-- ============================================================================
-- IMPORTANT: Must be set before lazy.nvim loads to ensure mappings work
-- Uncomment these lines if you want to use Space as leader key:
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- ============================================================================
-- Load Core Configuration
-- ============================================================================
-- Load general Neovim options and keymaps before plugins
require('core.options')   -- General vim options (indent, UI, etc)
require('core.keymaps')   -- General keymaps (non-plugin specific)

-- ============================================================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================================================
-- Automatically install lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim plugin manager...")

  -- Ensure parent directory exists before git clone
  local parent_dir = vim.fn.stdpath("data") .. "/lazy"
  vim.fn.mkdir(parent_dir, "p")

  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- Use latest stable release
    lazypath,
  })

  -- Check if installation was successful
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Failed to install lazy.nvim!")
    vim.api.nvim_err_writeln("Git output: " .. output)
    error("Cannot continue without lazy.nvim")
  end

  -- Verify that lazy.nvim was actually installed
  if not vim.loop.fs_stat(lazypath .. "/lua/lazy/init.lua") then
    vim.api.nvim_err_writeln("lazy.nvim directory created but files are missing!")
    error("lazy.nvim installation incomplete")
  end

  print("lazy.nvim installed! Please restart Neovim to load plugins.")
  -- Exit neovim after installation so user can restart
  vim.defer_fn(function()
    vim.cmd("quitall")
  end, 1000)
  return  -- Don't try to load lazy.nvim in this session
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Load Plugins
-- ============================================================================
-- Load all plugin specifications from lua/plugins/
-- Each file in plugins/ returns a table of plugin specs
require("lazy").setup({
  -- Import all plugin configuration files
  { import = "plugins.editor" },      -- Text editing enhancements
  { import = "plugins.lsp" },         -- LSP and code intelligence
  { import = "plugins.ui" },          -- UI enhancements and themes
  { import = "plugins.git" },         -- Git integration
  { import = "plugins.navigation" },  -- File navigation and fuzzy finding
  { import = "plugins.tools" },       -- Utility plugins
}, {
  -- Lazy.nvim configuration options
  ui = {
    -- Use simple border for lazy.nvim UI
    border = "rounded",
  },
  -- Check for plugin updates but don't auto-update
  checker = {
    enabled = true,
    notify = false,  -- Don't notify on updates
  },
  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- Disable some built-in plugins for faster startup
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- ============================================================================
-- Post-Plugin Configuration
-- ============================================================================
-- Any configuration that needs to run after all plugins are loaded
-- can be added here
