local fmt = string.format
local REQUIRED_KEYS = {"sigil-path", "lua-cache-path", "lua-colocation-path", "namespace", "modname", "lua-path", "src-path"}
local function new(modname, src_path, _1_)
  local prefix = _1_.prefix
  local extension = _1_.extension
  local opts = _1_
  if (nil == opts) then
    _G.error("Missing argument opts on fnl/hotpot/loader/record/module.fnl:9", 2)
  else
  end
  if (nil == extension) then
    _G.error("Missing argument extension on fnl/hotpot/loader/record/module.fnl:9", 2)
  else
  end
  if (nil == prefix) then
    _G.error("Missing argument prefix on fnl/hotpot/loader/record/module.fnl:9", 2)
  else
  end
  if (nil == src_path) then
    _G.error("Missing argument src-path on fnl/hotpot/loader/record/module.fnl:9", 2)
  else
  end
  if (nil == modname) then
    _G.error("Missing argument modname on fnl/hotpot/loader/record/module.fnl:9", 2)
  else
  end
  local _let_7_ = require("hotpot.loader.sigil")
  local SIGIL_FILE = _let_7_.SIGIL_FILE
  local _let_8_ = require("hotpot.loader")
  local cache_path_for_compiled_artefact = _let_8_["cache-path-for-compiled-artefact"]
  local src_path0 = vim.fs.normalize(src_path)
  local context_dir, code_path
  do
    local slashed_modname = vim.pesc(string.gsub(modname, "%.", "/"))
    local pattern = fmt("(.+/)(%s/%s(.*)%%.%s)", prefix, slashed_modname, extension)
    local case_9_, case_10_, case_11_ = string.gmatch(src_path0, pattern)()
    if ((nil ~= case_9_) and (nil ~= case_10_) and (case_11_ == "")) then
      local context_dir0 = case_9_
      local code_dir = case_10_
      context_dir, code_path = context_dir0, code_dir, modname
    elseif ((nil ~= case_9_) and (nil ~= case_10_) and (case_11_ == "/init")) then
      local context_dir0 = case_9_
      local code_dir = case_10_
      context_dir, code_path = context_dir0, code_dir, (modname .. ".init")
    else
      local _ = case_9_
      context_dir, code_path = error(fmt("Hotpot could not extract context-dir and code-path from %s", src_path0))
    end
  end
  local namespace
  do
    local case_13_ = string.match(context_dir, ".+/(.-)/$")
    if (nil ~= case_13_) then
      local namespace0 = case_13_
      namespace = namespace0
    elseif (case_13_ == nil) then
      namespace = string.match(context_dir, "([^/]-)/$")
    else
      namespace = nil
    end
  end
  local sigil_path = (context_dir .. SIGIL_FILE)
  local lua_code_path
  do
    local pattern = fmt("(%s)(/.+%%.)(%s)$", prefix, extension)
    lua_code_path = string.gsub(code_path, pattern, "lua%2lua")
  end
  local lua_cache_path = cache_path_for_compiled_artefact(namespace, lua_code_path)
  local lua_colocation_path = (context_dir .. lua_code_path)
  local record = {["sigil-path"] = sigil_path, ["src-path"] = src_path0, ["lua-path"] = lua_cache_path, ["lua-cache-path"] = lua_cache_path, ["lua-colocation-path"] = lua_colocation_path, ["colocation-root-path"] = context_dir, ["cache-root-path"] = cache_path_for_compiled_artefact(namespace), namespace = namespace, modname = modname}
  local unsafely_3f = (opts["unsafely?"] or false)
  if (true == not unsafely_3f) then
    for _, key in ipairs(REQUIRED_KEYS) do
      assert(record[key], fmt("could not generate required key: %s from src-path: %s", key, src_path0))
    end
  else
  end
  return record
end
return {new = new}