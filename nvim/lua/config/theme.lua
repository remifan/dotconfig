local M = {}

local state_path = vim.fs.joinpath(vim.fn.stdpath("state"), "theme-preferences.json")

local defaults = {
  mode = "auto",
  dark_theme = "boo",
  light_theme = "koda",
}

local valid_modes = {
  auto = true,
  dark = true,
  light = true,
}

local valid_dark_themes = {
  boo = true,
  koda = true,
}

local valid_light_themes = {
  koda = true,
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Theme" })
end

local function merge_preferences(user)
  return vim.tbl_extend("force", vim.deepcopy(defaults), user or {})
end

local function read_preferences()
  local file = io.open(state_path, "r")
  if not file then
    return vim.deepcopy(defaults)
  end

  local ok, decoded = pcall(vim.json.decode, file:read("*a"))
  file:close()
  if not ok or type(decoded) ~= "table" then
    return vim.deepcopy(defaults)
  end

  if decoded.light_theme == "achroma" then
    decoded.light_theme = "koda"
  end
  if decoded.dark_theme == "achroma" then
    decoded.dark_theme = "koda"
  end

  return merge_preferences(decoded)
end

local function write_preferences(preferences)
  local dir = vim.fs.dirname(state_path)
  vim.fn.mkdir(dir, "p")

  local file = assert(io.open(state_path, "w"))
  file:write(vim.json.encode(preferences))
  file:write("\n")
  file:close()
end

local preferences = read_preferences()

local function save_preferences()
  write_preferences(preferences)
end

local function apply_boo()
  local ok, boo = pcall(require, "boo-colorscheme")
  if not ok then
    notify("boo theme is not installed", vim.log.levels.WARN)
    return false
  end

  boo.use({
    italic = true,
    theme = "boo",
  })
  vim.cmd.colorscheme("boo")
  return true
end

local function apply_koda(mode)
  local ok, koda = pcall(require, "koda")
  if not ok then
    notify("koda theme is not installed", vim.log.levels.WARN)
    return false
  end

  koda.setup({})
  vim.cmd.colorscheme(mode == "light" and "koda-light" or "koda-dark")
  return true
end

local function apply_dark_theme()
  if preferences.dark_theme == "koda" then
    return apply_koda("dark")
  end
  return apply_boo()
end

local function apply_light_theme()
  return apply_koda("light")
end

local function apply_for_background()
  if vim.o.background == "light" then
    apply_light_theme()
  else
    apply_dark_theme()
  end
end

function M.apply_current()
  -- NVIM_THEME env var overrides persisted preferences (per-client control)
  local env_mode = vim.env.NVIM_THEME
  local mode = env_mode or preferences.mode

  if mode == "dark" then
    vim.o.background = "dark"
    apply_dark_theme()
    return
  end

  if mode == "light" then
    vim.o.background = "light"
    apply_light_theme()
    return
  end

  -- Auto mode: follow Neovim's native background detection
  apply_for_background()
end

function M.get_preferences()
  return vim.deepcopy(preferences)
end

local function format_status()
  return string.format(
    "mode=%s dark=%s light=%s",
    preferences.mode,
    preferences.dark_theme,
    preferences.light_theme
  )
end

function M.set_mode(mode)
  if not valid_modes[mode] then
    notify("invalid mode: " .. mode, vim.log.levels.ERROR)
    return
  end

  preferences.mode = mode
  save_preferences()
  M.apply_current()
  notify("updated theme settings: " .. format_status())
end

function M.set_dark_theme(theme)
  if not valid_dark_themes[theme] then
    notify("invalid dark theme: " .. theme, vim.log.levels.ERROR)
    return
  end

  preferences.dark_theme = theme
  save_preferences()
  if preferences.mode == "dark" then
    M.apply_current()
  elseif preferences.mode == "auto" and vim.o.background == "dark" then
    apply_dark_theme()
  end
  notify("updated theme settings: " .. format_status())
end

function M.set_light_theme(theme)
  if not valid_light_themes[theme] then
    notify("invalid light theme: " .. theme, vim.log.levels.ERROR)
    return
  end

  preferences.light_theme = theme
  save_preferences()
  if preferences.mode == "light" then
    M.apply_current()
  elseif preferences.mode == "auto" and vim.o.background == "light" then
    apply_light_theme()
  end
  notify("updated theme settings: " .. format_status())
end

local function select_mode()
  local items = {
    { label = "Auto switch", value = "auto" },
    { label = "Force dark", value = "dark" },
    { label = "Force light", value = "light" },
  }

  vim.ui.select(items, {
    prompt = "Theme mode",
    format_item = function(item)
      local current = preferences.mode == item.value and " (current)" or ""
      return item.label .. current
    end,
  }, function(choice)
    if choice then
      M.set_mode(choice.value)
    end
  end)
end

local function select_dark_theme()
  local items = {
    { label = "boo", value = "boo" },
    { label = "koda", value = "koda" },
  }

  vim.ui.select(items, {
    prompt = "Default dark theme",
    format_item = function(item)
      local current = preferences.dark_theme == item.value and " (current)" or ""
      local default = item.value == "boo" and " (default)" or ""
      return item.label .. current .. default
    end,
  }, function(choice)
    if choice then
      M.set_dark_theme(choice.value)
    end
  end)
end

local function select_light_theme()
  local items = {
    { label = "koda", value = "koda" },
  }

  vim.ui.select(items, {
    prompt = "Default light theme",
    format_item = function(item)
      local current = preferences.light_theme == item.value and " (current)" or ""
      return item.label .. current
    end,
  }, function(choice)
    if choice then
      M.set_light_theme(choice.value)
    end
  end)
end

function M.open_menu()
  local items = {
    { label = "Theme mode", value = "mode" },
    { label = "Default dark theme", value = "dark_theme" },
    { label = "Default light theme", value = "light_theme" },
  }

  vim.ui.select(items, {
    prompt = "Theme settings",
    format_item = function(item)
      if item.value == "mode" then
        return item.label .. ": " .. preferences.mode
      end
      if item.value == "dark_theme" then
        return item.label .. ": " .. preferences.dark_theme
      end
      return item.label .. ": " .. preferences.light_theme
    end,
  }, function(choice)
    if not choice then
      return
    end

    if choice.value == "mode" then
      select_mode()
      return
    end

    if choice.value == "dark_theme" then
      select_dark_theme()
      return
    end

    select_light_theme()
  end)
end

function M.command(opts)
  local args = opts.fargs or {}
  if #args == 0 then
    M.open_menu()
    return
  end

  if #args ~= 2 then
    notify("usage: ThemeSelect [mode|dark|light] <value>", vim.log.levels.ERROR)
    return
  end

  local key = args[1]
  local value = args[2]

  if key == "mode" then
    M.set_mode(value)
    return
  end

  if key == "dark" then
    M.set_dark_theme(value)
    return
  end

  if key == "light" then
    M.set_light_theme(value)
    return
  end

  notify("usage: ThemeSelect [mode|dark|light] <value>", vim.log.levels.ERROR)
end

function M.complete(arg_lead, cmd_line)
  local parts = vim.split(cmd_line, "%s+", { trimempty = true })
  local completing_value = cmd_line:match("%s$") ~= nil and #parts == 2

  if #parts <= 2 and not completing_value then
    return vim.tbl_filter(function(item)
      return vim.startswith(item, arg_lead)
    end, { "mode", "dark", "light" })
  end

  local key = parts[2]
  local values = {}
  if key == "mode" then
    values = { "auto", "dark", "light" }
  elseif key == "dark" then
    values = { "boo", "koda" }
  elseif key == "light" then
    values = { "koda" }
  end

  return vim.tbl_filter(function(item)
    return vim.startswith(item, arg_lead)
  end, values)
end

function M.setup()
  vim.api.nvim_create_user_command("ThemeSelect", function(opts)
    M.command(opts)
  end, {
    nargs = "*",
    complete = function(arg_lead, cmd_line)
      return M.complete(arg_lead, cmd_line)
    end,
    desc = "Select or configure Neovim theme mode",
  })

  M.apply_current()
end

return M
