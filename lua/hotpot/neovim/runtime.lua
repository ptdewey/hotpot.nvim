local fmt = string.format
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_del_augroup_by_id = vim.api.nvim_del_augroup_by_id
local function generate_runtime_loaders(plugin_type, glob, path, _3fopts)
  local _let_1_ = require("hotpot.loader")
  local make_record_loader = _let_1_["make-record-loader"]
  local _let_2_ = require("hotpot.loader.record")
  local fetch_record = _let_2_.fetch
  local _let_3_ = require("hotpot.lang.fennel")
  local make_runtime_record = _let_3_["make-runtime-record"]
  local _let_4_ = require("hotpot.searcher")
  local glob_search = _let_4_["glob-search"]
  local _let_5_ = require("hotpot.fs")
  local file_exists_3f = _let_5_["file-exists?"]
  local tbl_26_ = {}
  local i_27_ = 0
  for _, fnl_path in ipairs(glob_search({glob = glob, path = path, ["all?"] = true})) do
    local val_28_
    local function _6_(...)
      if (nil ~= ...) then
        local lua_twin_path = ...
        local function _7_(...)
          if (... == false) then
            local plugin_type0 = (string.match(fnl_path, ("/(after)/" .. plugin_type)) or plugin_type)
            local modname = string.gsub(string.match(fnl_path, (plugin_type0 .. "/(.-)%.fnl$")), "/", ".")
            local record_opts = vim.tbl_extend("force", {["runtime-type"] = plugin_type0}, (_3fopts or {}))
            local fresh_record = make_runtime_record(modname, fnl_path, record_opts)
            local record = (fetch_record(fresh_record["lua-path"]) or fresh_record)
            local case_8_ = make_record_loader(record)
            local and_9_ = (nil ~= case_8_)
            if and_9_ then
              local loader = case_8_
              and_9_ = ("function" == type(loader))
            end
            if and_9_ then
              local loader = case_8_
              return {loader = loader, modname = record.modname, modpath = record["src-path"]}
            else
              local and_11_ = (nil ~= case_8_)
              if and_11_ then
                local msg = case_8_
                and_11_ = ("string" == type(msg))
              end
              if and_11_ then
                local msg = case_8_
                return vim.notify(msg, vim.log.levels.ERROR)
              else
                return nil
              end
            end
          elseif (... == true) then
            return nil
          else
            return nil
          end
        end
        return _7_(file_exists_3f(lua_twin_path))
      elseif (... == true) then
        return nil
      else
        return nil
      end
    end
    val_28_ = _6_(string.gsub(fnl_path, "fnl$", "lua"))
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  return tbl_26_
end
local function find_runtime_plugins(plugin_type, glob, _3fpath)
  local _let_17_ = require("hotpot.fs")
  local file_exists_3f = _let_17_["file-exists?"]
  local rm_file = _let_17_["rm-file"]
  local _let_18_ = require("hotpot.searcher")
  local glob_search = _let_18_["glob-search"]
  local _let_19_ = require("hotpot.loader.record")
  local fetch = _let_19_.fetch
  local drop = _let_19_.drop
  local path = (_3fpath or vim.go.rtp)
  local loaders = generate_runtime_loaders(plugin_type, glob, path)
  for _, _20_ in ipairs(loaders) do
    local loader = _20_.loader
    local modname = _20_.modname
    local modpath = _20_.modpath
    local case_21_, case_22_ = pcall(loader, modname, modpath)
    if ((case_21_ == true) and true) then
      local _0 = case_22_
    elseif ((case_21_ == false) and (nil ~= case_22_)) then
      local e = case_22_
      vim.notify(e, vim.log.levels.ERROR)
    else
    end
  end
  for _, s_path in ipairs({"lua/hotpot-runtime-%s/**/*.lua", "lua/hotpot-runtime-after/%s/**/*.lua"}) do
    for _0, lua_path in ipairs(glob_search({glob = fmt(s_path, plugin_type), ["all?"] = true})) do
      local case_24_ = fetch(lua_path)
      if (nil ~= case_24_) then
        local record = case_24_
        if not file_exists_3f(record["src-path"]) then
          rm_file(lua_path)
          drop(record)
        else
        end
      else
      end
    end
  end
  return nil
end
local function find_ftplugins(event)
  local filetype = event.match
  find_runtime_plugins("ftplugin", fmt("ftplugin/%s.fnl", filetype))
  find_runtime_plugins("ftplugin", fmt("ftplugin/%s_*.fnl", filetype))
  find_runtime_plugins("ftplugin", fmt("ftplugin/%s/*.fnl", filetype))
  find_runtime_plugins("indent", fmt("indent/%s.fnl", filetype))
  return nil
end
local enabled_3f = false
local augroup_id = nil
local function enable()
  if (vim.go.loadplugins and not enabled_3f) then
    augroup_id = nvim_create_augroup("hotpot-nvim-runtime-loaders", {})
    enabled_3f = true
    nvim_create_autocmd("FileType", {callback = find_ftplugins, desc = "Execute ftplugin/*.fnl files", group = augroup_id})
    generate_runtime_loaders("lsp", "lsp/*.fnl", vim.go.rtp, {["compile-only?"] = true})
    do
      local _let_27_ = require("hotpot.fs")
      local file_exists_3f = _let_27_["file-exists?"]
      local rm_file = _let_27_["rm-file"]
      local _let_28_ = require("hotpot.searcher")
      local glob_search = _let_28_["glob-search"]
      local _let_29_ = require("hotpot.loader.record")
      local fetch = _let_29_.fetch
      local drop = _let_29_.drop
      local _let_30_ = require("hotpot.loader")
      local cache_path_for_compiled_artefact = _let_30_["cache-path-for-compiled-artefact"]
      local cache_prefix = cache_path_for_compiled_artefact()
      for _, lua_path in ipairs(glob_search({glob = "lsp/*.lua", ["all?"] = true})) do
        if (1 == string.find(lua_path, cache_prefix, 1, true)) then
          local case_31_ = fetch(lua_path)
          if (nil ~= case_31_) then
            local record = case_31_
            if not file_exists_3f(record["src-path"]) then
              rm_file(lua_path)
              drop(record)
            else
            end
          else
          end
        else
        end
      end
    end
    if (1 == vim.v.vim_did_enter) then
      return find_runtime_plugins("plugin", "plugin/**/*.fnl")
    else
      local function _35_()
        return find_runtime_plugins("plugin", "plugin/**/*.fnl")
      end
      return nvim_create_autocmd("VimEnter", {callback = _35_, desc = "Execute plugin/**/*.fnl files", once = true, group = augroup_id})
    end
  else
    return nil
  end
end
local function disable()
  if augroup_id then
    nvim_del_augroup_by_id(augroup_id)
    augroup_id = nil
    enabled_3f = false
    return nil
  else
    return nil
  end
end
return {enable = enable, disable = disable}