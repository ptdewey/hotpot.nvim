package.preload["test.utils"] = package.preload["test.utils"] or function(...)
  local function read_file(path)
    return table.concat(vim.fn.readfile(path), "\\n")
  end
  local function write_file(path, lines)
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    local fh = assert(io.open(path, "w"), ("fs.write-file! io.open failed:" .. path))
    local function close_handlers_13_(ok_14_, ...)
      fh:close()
      if ok_14_ then
        return ...
      else
        return error(..., 0)
      end
    end
    local function _2_()
      return fh:write(lines)
    end
    local _4_
    do
      local t_3_ = _G
      if (nil ~= t_3_) then
        t_3_ = t_3_.package
      else
      end
      if (nil ~= t_3_) then
        t_3_ = t_3_.loaded
      else
      end
      if (nil ~= t_3_) then
        t_3_ = t_3_.fennel
      else
      end
      _4_ = t_3_
    end
    local or_8_ = _4_ or _G.debug
    if not or_8_ then
      local function _9_()
        return ""
      end
      or_8_ = {traceback = _9_}
    end
    return close_handlers_13_(_G.xpcall(_2_, or_8_.traceback))
  end
  local results = {passes = 0, fails = 0}
  local function OK(message)
    results.passes = (1 + results.passes)
    return print("OK", message)
  end
  local function FAIL(message)
    results.fails = (1 + results.fails)
    return print("FAIL", message)
  end
  local function exit()
    print("\n")
    return os.exit(results.fails)
  end
  vim.opt.runtimepath:prepend(vim.loop.cwd())
  require("hotpot")
  return {["write-file"] = write_file, ["read-file"] = read_file, OK = OK, FAIL = FAIL, exit = exit, NVIM_APPNAME = vim.env.NVIM_APPNAME}
end
local _local_10_ = require("test.utils")
local FAIL = _local_10_.FAIL
local NVIM_APPNAME = _local_10_.NVIM_APPNAME
local OK = _local_10_.OK
local exit = _local_10_.exit
local read_file = _local_10_["read-file"]
local write_file = _local_10_["write-file"]
local function p(x)
  return (vim.fn.stdpath("config") .. x)
end
local _local_11_ = require("hotpot.api.cache")
local cache_prefix = _local_11_["cache-prefix"]
local lsp_fnl_path = p("/lsp/test_server.fnl")
local lsp_lua_path = (cache_prefix() .. "/" .. NVIM_APPNAME .. "/lsp/test_server.lua")
write_file(lsp_fnl_path, "(set _G.lsp_val 42)")
do
  local case_12_
  do
    local fname = string.format("sub-nvim-%d.lua", vim.loop.hrtime())
    write_file(fname, string.format(("vim.opt.runtimepath:prepend(vim.loop.cwd())\n                             require('hotpot')\n                             " .. "vim.defer_fn(function() os.exit(_G.lsp_val or 0) end, 50)")))
    vim.cmd(string.format("!%s +'set columns=1000' --headless -S %s", (vim.env.NVIM_BIN or "nvim"), fname))
    case_12_ = vim.v.shell_error
  end
  if (case_12_ == 0) then
    OK(string.format(("lsp/*.fnl compiled but not executed" or "")))
  else
    local __1_auto = case_12_
    FAIL(string.format(("lsp/*.fnl compiled but not executed" or "")))
  end
end
do
  local case_14_ = vim.loop.fs_access(lsp_lua_path, "R")
  if (case_14_ == true) then
    OK(string.format(("lsp lua file exists in module cache" or "")))
  else
    local __1_auto = case_14_
    FAIL(string.format(("lsp lua file exists in module cache" or "")))
  end
end
local stat_before = vim.loop.fs_stat(lsp_lua_path)
do
  local case_16_
  do
    local fname = string.format("sub-nvim-%d.lua", vim.loop.hrtime())
    write_file(fname, string.format(("vim.opt.runtimepath:prepend(vim.loop.cwd())\n                             require('hotpot')\n                             " .. "vim.defer_fn(function() os.exit(_G.lsp_val or 0) end, 50)")))
    vim.cmd(string.format("!%s +'set columns=1000' --headless -S %s", (vim.env.NVIM_BIN or "nvim"), fname))
    case_16_ = vim.v.shell_error
  end
  if (case_16_ == 0) then
    OK(string.format(("lsp/*.fnl not executed on second run" or "")))
  else
    local __1_auto = case_16_
    FAIL(string.format(("lsp/*.fnl not executed on second run" or "")))
  end
end
local stat_after = vim.loop.fs_stat(lsp_lua_path)
do
  local case_18_ = ((stat_before.mtime.sec == stat_after.mtime.sec) and (stat_before.mtime.nsec == stat_after.mtime.nsec))
  if (case_18_ == true) then
    OK(string.format(("lsp lua file was not recompiled" or "")))
  else
    local __1_auto = case_18_
    FAIL(string.format(("lsp lua file was not recompiled" or "")))
  end
end
vim.loop.fs_unlink(lsp_fnl_path)
do
  local case_20_
  do
    local fname = string.format("sub-nvim-%d.lua", vim.loop.hrtime())
    write_file(fname, string.format(("vim.opt.runtimepath:prepend(vim.loop.cwd())\n                             require('hotpot')\n                             " .. "vim.defer_fn(function() os.exit(0) end, 50)")))
    vim.cmd(string.format("!%s +'set columns=1000' --headless -S %s", (vim.env.NVIM_BIN or "nvim"), fname))
    case_20_ = vim.v.shell_error
  end
  if (case_20_ == 0) then
    OK(string.format(("sub-nvim starts after lsp file removed" or "")))
  else
    local __1_auto = case_20_
    FAIL(string.format(("sub-nvim starts after lsp file removed" or "")))
  end
end
if (1 ~= vim.fn.has("win32")) then
  local case_22_ = vim.loop.fs_access(lsp_lua_path, "R")
  if (case_22_ == false) then
    OK(string.format(("lsp lua file removed" or "")))
  else
    local __1_auto = case_22_
    FAIL(string.format(("lsp lua file removed" or "")))
  end
else
end
local lsp_fnl_path_2 = p("/lsp/x.fnl")
local lsp_lua_sibling = p("/lsp/x.lua")
local lsp_compiled_path = (cache_prefix() .. "/" .. NVIM_APPNAME .. "/lsp/x.lua")
write_file(lsp_fnl_path_2, "(set _G.lsp_x 99)")
write_file(lsp_lua_sibling, "_G.lsp_x = 1")
do
  local case_25_
  do
    local fname = string.format("sub-nvim-%d.lua", vim.loop.hrtime())
    write_file(fname, string.format(("vim.opt.runtimepath:prepend(vim.loop.cwd())\n                             require('hotpot')\n                             " .. "vim.defer_fn(function() os.exit(_G.lsp_x or 0) end, 50)")))
    vim.cmd(string.format("!%s +'set columns=1000' --headless -S %s", (vim.env.NVIM_BIN or "nvim"), fname))
    case_25_ = vim.v.shell_error
  end
  if (case_25_ == 0) then
    OK(string.format(("lsp/*.fnl not executed when lua sibling exists" or "")))
  else
    local __1_auto = case_25_
    FAIL(string.format(("lsp/*.fnl not executed when lua sibling exists" or "")))
  end
end
do
  local case_27_ = vim.loop.fs_access(lsp_compiled_path, "R")
  if (case_27_ == false) then
    OK(string.format(("fnl never compiled when lua sibling exists" or "")))
  else
    local __1_auto = case_27_
    FAIL(string.format(("fnl never compiled when lua sibling exists" or "")))
  end
end
return exit()