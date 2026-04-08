-- ============================================================================
-- LSP (Language Server Protocol) Configuration
-- ============================================================================

-- Mason setup first (adds mason bin/ to PATH before executable checks)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then mason.setup() end

-- Load LSP keymaps, handlers, and built-in completion setup
require('config.lsp.handlers')

-- ============================================================================
-- LSP Server Selection
-- ============================================================================

local all_servers = {
  { name = "lua_ls",        desc = "Lua",                   via = "mason" },
  { name = "rust_analyzer", desc = "Rust",                  via = "mason" },
  { name = "pyright",       desc = "Python",                via = "mason" },
  { name = "tinymist",      desc = "Typst",                 via = "mason" },
  { name = "verible",       desc = "Verilog/SystemVerilog", via = "mason" },
  { name = "lf",            desc = "Lingua Franca",         via = "lf.nvim" },
}

local config_path = vim.fn.stdpath('config') .. '/lsp-servers.json'

local function load_selection()
  local f = io.open(config_path, 'r')
  if not f then return nil end
  local ok, data = pcall(vim.json.decode, f:read('*a'))
  f:close()
  return ok and data or nil
end

local function save_selection(list)
  local f = io.open(config_path, 'w')
  if f then
    f:write(vim.json.encode(list))
    f:close()
  end
end

local function apply_servers(selected)
  -- Split by provider
  local mason_servers = {}
  local enable_lf = false
  local selected_set = {}
  for _, name in ipairs(selected) do
    selected_set[name] = true
  end
  for _, s in ipairs(all_servers) do
    if selected_set[s.name] then
      if s.via == "mason" then
        table.insert(mason_servers, s.name)
      elseif s.via == "lf.nvim" then
        enable_lf = true
      end
    end
  end

  -- Mason-managed servers
  local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if mason_lsp_ok then
    local is_win_arm64 = vim.fn.has('win32') == 1
      and vim.env.PROCESSOR_ARCHITECTURE == 'ARM64'

    mason_lspconfig.setup({
      ensure_installed = not is_win_arm64 and mason_servers or {},
      automatic_enable = {
        exclude = { "verible" },
      }
    })

    if is_win_arm64 then
      for _, server in ipairs(mason_servers) do
        if server ~= "verible" then
          vim.lsp.enable(server)
        end
      end
    end
  end

  -- Lingua Franca (managed by lf.nvim)
  if enable_lf then
    local lf_ok, lf = pcall(require, "lf")
    if lf_ok then
      -- Auto-detect LSP jar from LFLspInstall location
      local function find_lf_jar()
        local data_dir = vim.fn.stdpath('data') .. '/lf-lsp'
        local jars = vim.fn.glob(data_dir .. '/lsp-*-all.jar', false, true)
        if #jars > 0 then return jars[#jars] end  -- latest version
        return nil
      end

      local jar = find_lf_jar()

      -- Auto-install jar if missing
      if not jar then
        vim.defer_fn(function()
          if vim.fn.exists(':LFLspInstall') == 2 then
            vim.cmd('LFLspInstall')
          end
        end, 500)
      end

      lf.setup({
        enable_lsp = jar ~= nil,
        syntax = {
          auto_detect_target = true,
          target_language = nil,
          indent = { size = 4, use_tabs = false },
        },
        diagram = { no_browser = true },
        lsp = {
          jar_path = jar,
          java_cmd = "java",
          java_args = { "-Xmx2G" },
          auto_start = true,
        },
        build = {
          auto_validate = true,
          show_progress = true,
          open_quickfix = true,
        },
        keymaps = {
          build = "<leader>lb",
          run = "<leader>lr",
          diagram = "<leader>ld",
          library = "<leader>ll",
          show_ast = "<leader>la",
        },
      })
    end
  end
end

-- ============================================================================
-- Interactive Server Picker
-- ============================================================================

local function show_server_picker(callback)
  local selected = {}
  -- Restore previous selection if available, otherwise select all
  local prev = load_selection()
  if prev then
    for _, s in ipairs(all_servers) do
      selected[s.name] = vim.tbl_contains(prev, s.name)
    end
  else
    for _, s in ipairs(all_servers) do
      selected[s.name] = true
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local function render()
    local lines = {}
    for _, s in ipairs(all_servers) do
      local mark = selected[s.name] and "[x]" or "[ ]"
      table.insert(lines, string.format("  %s %-20s %-22s [%s]", mark, s.name, s.desc, s.via))
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end

  render()

  local width = 64
  local height = #all_servers
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' LSP Servers (<Space> toggle, <CR> confirm) ',
    title_pos = 'center',
  })

  local function finish()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    local result = {}
    for _, s in ipairs(all_servers) do
      if selected[s.name] then
        table.insert(result, s.name)
      end
    end
    callback(result)
  end

  vim.keymap.set('n', '<Space>', function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if line >= 1 and line <= #all_servers then
      selected[all_servers[line].name] = not selected[all_servers[line].name]
      render()
    end
  end, { buffer = buf })

  vim.keymap.set('n', '<CR>', finish, { buffer = buf })
  vim.keymap.set('n', 'q', finish, { buffer = buf })
  vim.keymap.set('n', '<Esc>', finish, { buffer = buf })
end

-- ============================================================================
-- Apply: first-run picker or load saved selection
-- ============================================================================

local selection = load_selection()
if selection then
  apply_servers(selection)
else
  vim.schedule(function()
    show_server_picker(function(chosen)
      save_selection(chosen)
      apply_servers(chosen)
      vim.notify('LSP servers configured: ' .. table.concat(chosen, ', ')
        .. '\nRestarting in a moment...')
      -- Brief delay so the user sees the message, then restart.
      -- Mason's ensure_installed continues installing after restart.
      vim.defer_fn(function() vim.cmd('restart') end, 2000)
    end)
  end)
end

-- Re-run picker anytime
vim.api.nvim_create_user_command('LspServerSelect', function()
  show_server_picker(function(chosen)
    save_selection(chosen)
    apply_servers(chosen)
    vim.notify('LSP servers updated. Restart nvim for changes to take effect.')
  end)
end, { desc = 'Select LSP servers to install' })
