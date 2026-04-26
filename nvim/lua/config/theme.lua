local M = {}

local state_path = vim.fs.joinpath(vim.fn.stdpath("state"), "theme-preferences.json")

local defaults = {
  mode = "auto",
  dark_theme = "boo",
  light_theme = "achroma",
}

local valid_modes = {
  auto = true,
  dark = true,
  light = true,
}

local valid_dark_themes = {
  boo = true,
  achroma = true,
}

local valid_light_themes = {
  achroma = true,
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

local function set_background(mode)
  vim.api.nvim_set_option_value("background", mode, {})
end

local function apply_boo()
  local ok, boo = pcall(require, "boo-colorscheme")
  if not ok then
    notify("boo theme is not installed", vim.log.levels.WARN)
    return false
  end

  set_background("dark")
  boo.use({
    italic = true,
    theme = "boo",
  })
  vim.cmd.colorscheme("boo")
  return true
end

local function apply_achroma(mode)
  local ok, achroma = pcall(require, "achroma")
  if not ok then
    notify("achroma theme is not installed", vim.log.levels.WARN)
    return false
  end

  set_background(mode)
  achroma.setup({
    mode = mode,
    auto_dark_light = false,
  })
  vim.cmd.colorscheme("achroma")
  return true
end

local function apply_dark_theme()
  if preferences.dark_theme == "achroma" then
    return apply_achroma("dark")
  end

  return apply_boo()
end

local function apply_light_theme()
  return apply_achroma("light")
end

local function disable_auto_dark_mode()
  local ok, auto_dark_mode = pcall(require, "auto-dark-mode")
  if ok and auto_dark_mode.disable then
    auto_dark_mode.disable()
  end
end

local function enable_auto_dark_mode()
  local ok, auto_dark_mode = pcall(require, "auto-dark-mode")
  if not ok then
    apply_dark_theme()
    return
  end

  disable_auto_dark_mode()
  auto_dark_mode.setup({
    update_interval = 3000,
    fallback = "dark",
    set_dark_mode = function()
      apply_dark_theme()
    end,
    set_light_mode = function()
      apply_light_theme()
    end,
  })
end

function M.apply_current()
  if preferences.mode == "dark" then
    disable_auto_dark_mode()
    apply_dark_theme()
    return
  end

  if preferences.mode == "light" then
    disable_auto_dark_mode()
    apply_light_theme()
    return
  end

  enable_auto_dark_mode()
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
    { label = "achroma", value = "achroma" },
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
    { label = "achroma", value = "achroma" },
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
    values = { "boo", "achroma" }
  elseif key == "light" then
    values = { "achroma" }
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
