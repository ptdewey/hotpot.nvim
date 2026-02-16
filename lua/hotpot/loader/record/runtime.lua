local fmt = string.format
local REQUIRED_KEYS = {"namespace", "modname", "lua-path", "src-path"}
local function new(modname_suffix, src_path, opts)
  if (nil == opts) then
    _G.error("Missing argument opts on fnl/hotpot/loader/record/runtime.fnl:6", 2)
  else
  end
  if (nil == src_path) then
    _G.error("Missing argument src-path on fnl/hotpot/loader/record/runtime.fnl:6", 2)
  else
  end
  if (nil == modname_suffix) then
    _G.error("Missing argument modname-suffix on fnl/hotpot/loader/record/runtime.fnl:6", 2)
  else
  end
  assert(string.match(src_path, "fnl$"), "ftplugin records path must end in fnl")
  local _let_4_ = require("hotpot.loader")
  local cache_path_for_compiled_artefact = _let_4_["cache-path-for-compiled-artefact"]
  local _let_5_ = require("hotpot.fs")
  local join_path = _let_5_["join-path"]
  local runtime_type = opts["runtime-type"]
  local _ = assert(runtime_type, "runtime record requires opts.runtime-type such as ftplugin, plugin etc")
  local src_path0 = vim.fs.normalize(src_path)
  local ext = src_path0:match(".+%.(.-)$")
  local init_3f = (nil ~= string.find(src_path0, "init%....$"))
  local true_modname
  local _6_
  if init_3f then
    _6_ = ".init"
  else
    _6_ = ""
  end
  true_modname = (modname_suffix .. _6_)
  local compile_only_3f = (opts["compile-only?"] or false)
  local runtime_mod_prefix
  if compile_only_3f then
    runtime_mod_prefix = runtime_type
  else
    runtime_mod_prefix = fmt("hotpot-runtime-%s", runtime_type)
  end
  local modname = fmt("%s.%s", runtime_mod_prefix, modname_suffix)
  local context_pattern = fmt("(%s/%s%%.%s)$", runtime_type, string.gsub(modname_suffix, "[%(%)%%%+%-%*%?%[%]%^%$]", "%%%1"), ext)
  local path_inside_context_dir = string.match(src_path0, context_pattern)
  local path_to_context_dir = string.sub(src_path0, 1, (-1 * (#path_inside_context_dir + 1)))
  local lua_code_path
  if compile_only_3f then
    local inside = string.gsub(path_inside_context_dir, "fnl$", "lua")
    lua_code_path = inside
  else
    lua_code_path = string.gsub(string.gsub(path_inside_context_dir, ("^" .. vim.pesc(runtime_type)), join_path("lua", runtime_mod_prefix)), "fnl$", "lua")
  end
  local namespace
  do
    local case_10_ = string.match(path_to_context_dir, ".+/(.-)/$")
    if (nil ~= case_10_) then
      local namespace0 = case_10_
      namespace = namespace0
    elseif (case_10_ == nil) then
      namespace = string.match(path_to_context_dir, "([^/]-)/$")
    else
      namespace = nil
    end
  end
  local namespace0
  if compile_only_3f then
    namespace0 = namespace
  else
    namespace0 = ("hotpot-runtime-" .. namespace)
  end
  local lua_path = cache_path_for_compiled_artefact(namespace0, lua_code_path)
  local record = {["src-path"] = src_path0, ["lua-path"] = lua_path, ["cache-root-path"] = cache_path_for_compiled_artefact(namespace0), namespace = namespace0, modname = modname}
  local unsafely_3f = (opts["unsafely?"] or false)
  if (true == not unsafely_3f) then
    for _0, key in ipairs(REQUIRED_KEYS) do
      assert(record[key], fmt("could not generate required key: %s from src-path: %s", key, src_path0))
    end
  else
  end
  return record
end
return {new = new}