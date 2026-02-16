local M = {}
local fmt = string.format
local LOCAL_CONFIG_FILE = ".hotpot.lua"
local function lazy_traceback()
  local _let_1_ = require("hotpot.traceback")
  local traceback = _let_1_.traceback
  return traceback
end
local function lookup_local_config(file)
  local _let_2_ = require("hotpot.fs")
  local file_exists_3f = _let_2_["file-exists?"]
  if string.match(file, "%.hotpot%.lua$") then
    if file_exists_3f(file) then
      return vim.fs.normalize(file)
    else
      return nil
    end
  else
    local case_4_ = vim.fs.find(LOCAL_CONFIG_FILE, {path = file, upward = true, kind = "file"})
    if ((_G.type(case_4_) == "table") and (nil ~= case_4_[1])) then
      local path = case_4_[1]
      return vim.fs.normalize(vim.loop.fs_realpath(path))
    elseif ((_G.type(case_4_) == "table") and (case_4_[1] == nil)) then
      return nil
    else
      return nil
    end
  end
end
local function loadfile_local_config(path)
  local function _7_(...)
    local case_8_, case_9_ = ...
    if (nil ~= case_8_) then
      local loader = case_8_
      local function _10_(...)
        local case_11_, case_12_ = ...
        if ((case_11_ == true) and (nil ~= case_12_)) then
          local config = case_12_
          return vim.tbl_deep_extend("keep", config, {context = path}, M["default-config"]())
        elseif ((case_11_ == false) and (nil ~= case_12_)) then
          local e = case_12_
          return nil, e
        elseif ((case_11_ == nil) and (nil ~= case_12_)) then
          local e = case_12_
          return nil, e
        else
          return nil
        end
      end
      return _10_(pcall(loader))
    elseif ((case_8_ == false) and (nil ~= case_9_)) then
      local e = case_9_
      return nil, e
    elseif ((case_8_ == nil) and (nil ~= case_9_)) then
      local e = case_9_
      return nil, e
    else
      return nil
    end
  end
  return _7_(loadfile(path))
end
local windows_3f = (nil ~= string.find(string.lower(vim.loop.os_uname().sysname), "windows"))
M["windows?"] = function()
  return windows_3f
end
if not vim.loop.fs_realpath(vim.fn.stdpath("cache")) then
  vim.fn.mkdir(vim.fn.stdpath("cache"), "p")
else
end
local NVIM_CACHE_DIR = vim.fs.normalize(vim.loop.fs_realpath(vim.fn.stdpath("cache")))
M["cache-root-path"] = function()
  local _let_16_ = require("hotpot.fs")
  local join_path = _let_16_["join-path"]
  return join_path(NVIM_CACHE_DIR, "hotpot")
end
M["default-config"] = function()
  local function _17_(src)
    return src
  end
  return {compiler = {modules = {}, macros = {env = "_COMPILER"}, preprocessor = _17_, traceback = "hotpot"}, enable_hotpot_diagnostics = true}
end
local user_config = M["default-config"]()
M["user-config"] = function()
  return user_config
end
M["set-user-config"] = function(given_config)
  local new_config = M["default-config"]()
  for _, k in ipairs({"preprocessor", "modules", "macros", "traceback"}) do
    local case_18_
    do
      local t_19_ = given_config
      if (nil ~= t_19_) then
        t_19_ = t_19_.compiler
      else
      end
      if (nil ~= t_19_) then
        t_19_ = t_19_[k]
      else
      end
      case_18_ = t_19_
    end
    if (nil ~= case_18_) then
      local val = case_18_
      new_config["compiler"][k] = val
    else
    end
  end
  do
    local case_23_
    do
      local t_24_ = given_config
      if (nil ~= t_24_) then
        t_24_ = t_24_.enable_hotpot_diagnostics
      else
      end
      case_23_ = t_24_
    end
    if (nil ~= case_23_) then
      local val = case_23_
      new_config["enable_hotpot_diagnostics"] = val
    else
    end
  end
  do
    local case_27_ = new_config.compiler.traceback
    if (case_27_ == "hotpot") then
    elseif (case_27_ == "fennel") then
    else
      local _ = case_27_
      error("invalid config.compiler.traceback value, must be 'hotpot' or 'fennel'")
    end
  end
  user_config = new_config
  return user_config
end
M["lookup-local-config"] = function(file)
  return lookup_local_config(file)
end
M["loadfile-local-config"] = function(config_path)
  local case_29_, case_30_ = loadfile_local_config(config_path)
  if (nil ~= case_29_) then
    local config = case_29_
    return config
  elseif ((case_29_ == nil) and (nil ~= case_30_)) then
    local err = case_30_
    vim.notify(fmt(("Hotpot could not load local config due to lua error.\n" .. "Path: %s\n" .. "Error: %s"), config_path, err), vim.log.levels.WARN)
    return nil
  elseif (case_29_ == nil) then
    vim.notify(fmt(("Hotpot found local config but it return nil. " .. "Please update it to return a table instead of nil.\n" .. "Path: %s\n"), config_path), vim.log.levels.WARN)
    return nil
  else
    return nil
  end
end
M["config-for-context"] = function(file)
  if (nil == file) then
    return M["user-config"]()
  else
    local case_32_ = M["lookup-local-config"](file)
    if (case_32_ == nil) then
      return M["user-config"]()
    elseif (nil ~= case_32_) then
      local config_path = case_32_
      local case_33_ = M["loadfile-local-config"](config_path)
      if (nil ~= case_33_) then
        local config = case_33_
        return config
      elseif (case_33_ == nil) then
        vim.notify("Using safe defaults", vim.log.levels.WARN)
        return M["default-config"]()
      else
        return nil
      end
    else
      return nil
    end
  end
end
M["set-user-config"](M["default-config"]())
M["proxied-keys"] = "traceback"
local function _37_(_241, _242)
  if (_242 == "traceback") then
    return lazy_traceback()
  else
    return nil
  end
end
return setmetatable(M, {__index = _37_})