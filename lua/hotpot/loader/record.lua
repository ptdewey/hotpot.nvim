local fmt = string.format
local _local_1_ = require("hotpot.fs")
local file_exists_3f = _local_1_["file-exists?"]
local file_missing_3f = _local_1_["file-missing?"]
local read_file_21 = _local_1_["read-file!"]
local file_stat = _local_1_["file-stat"]
local rm_file = _local_1_["rm-file"]
local make_path = _local_1_["make-path"]
local join_path = _local_1_["join-path"]
local _local_2_ = require("hotpot.runtime")
local windows_3f = _local_2_["windows?"]
local cache_root_path = _local_2_["cache-root-path"]
local uri_encode
local and_3_ = vim.uri_encode
if and_3_ then
  local function _4_(_241)
    return vim.uri_encode(_241, "rfc2396")
  end
  and_3_ = _4_
end
local or_5_ = and_3_
if not or_5_ then
  local function _6_(str)
    local _let_7_ = require("bit")
    local tohex = _let_7_.tohex
    local percent_encode_char
    local function _8_(_241)
      return ("%" .. tohex(string.byte(_241), 2))
    end
    percent_encode_char = _8_
    local rfc2396_pattern = "([^A-Za-z0-9%-_.!~*'()])"
    return (string.gsub(str, rfc2396_pattern, percent_encode_char))
  end
  or_5_ = _6_
end
uri_encode = or_5_
local INDEX_ROOT_PATH = join_path(cache_root_path(), "index")
local INDEX_VERSION = 3
local RECORD_TYPE_MODULE = 1
local RECORD_TYPE_RUNTIME = 2
local function module_3f(r)
  local _10_
  do
    local t_9_ = r
    if (nil ~= t_9_) then
      t_9_ = t_9_.type
    else
    end
    _10_ = t_9_
  end
  return (RECORD_TYPE_MODULE == _10_)
end
local function runtime_3f(r)
  local _13_
  do
    local t_12_ = r
    if (nil ~= t_12_) then
      t_12_ = t_12_.type
    else
    end
    _13_ = t_12_
  end
  return (RECORD_TYPE_RUNTIME == _13_)
end
local function path__3eindex_key(path)
  if (nil == path) then
    _G.error("Missing argument path on fnl/hotpot/loader/record.fnl:38", 2)
  else
  end
  local normalize_path = vim.fs.normalize(path)
  local uri_path = (uri_encode(normalize_path, "rfc2396") .. "-metadata.mpack")
  local uri_index_path = join_path(INDEX_ROOT_PATH, uri_path)
  if (not windows_3f or (windows_3f and (#uri_index_path < 259))) then
    return uri_index_path
  else
    local sha_path = vim.fn.sha256(normalize_path)
    local sha_index_path = (join_path(INDEX_ROOT_PATH, sha_path) .. "-metadata.mpack")
    if (#sha_index_path < 259) then
      return sha_index_path
    else
      return false, string.format(("The generated index-path for %s was over windows " .. "maximum allowed path length. You may encounter " .. "issues with building new versions of this file. " .. "Consider trying `:h hotpot-dot-hotpot` with build = true."), path)
    end
  end
end
local function load(lua_path)
  local function _18_(...)
    if (nil ~= ...) then
      local index_path = ...
      local function _19_(...)
        if (... == true) then
          local function _20_(...)
            if (nil ~= ...) then
              local fin = ...
              local function _21_(...)
                if (nil ~= ...) then
                  local bytes = ...
                  local function _22_(...)
                    if (... == true) then
                      local function _23_(...)
                        local case_24_, case_25_ = ...
                        if ((case_24_ == true) and ((_G.type(case_25_) == "table") and (case_25_.version == INDEX_VERSION) and (nil ~= case_25_.data))) then
                          local data = case_25_.data
                          return data
                        else
                          local _ = case_24_
                          local function _26_(...)
                            if (nil ~= ...) then
                              local index_path0 = ...
                              local function _27_(...)
                                if (... == true) then
                                  local function _28_(...)
                                    if (... == true) then
                                      return nil
                                    else
                                      local _0 = ...
                                      return nil
                                    end
                                  end
                                  return _28_(rm_file(index_path0))
                                else
                                  local _0 = ...
                                  return nil
                                end
                              end
                              return _27_(file_exists_3f(index_path0))
                            else
                              local _0 = ...
                              return nil
                            end
                          end
                          return _26_(path__3eindex_key(lua_path))
                        end
                      end
                      return _23_(pcall(vim.mpack.decode, bytes))
                    else
                      local _ = ...
                      local function _33_(...)
                        if (nil ~= ...) then
                          local index_path0 = ...
                          local function _34_(...)
                            if (... == true) then
                              local function _35_(...)
                                if (... == true) then
                                  return nil
                                else
                                  local _0 = ...
                                  return nil
                                end
                              end
                              return _35_(rm_file(index_path0))
                            else
                              local _0 = ...
                              return nil
                            end
                          end
                          return _34_(file_exists_3f(index_path0))
                        else
                          local _0 = ...
                          return nil
                        end
                      end
                      return _33_(path__3eindex_key(lua_path))
                    end
                  end
                  return _22_(fin:close())
                else
                  local _ = ...
                  local function _40_(...)
                    if (nil ~= ...) then
                      local index_path0 = ...
                      local function _41_(...)
                        if (... == true) then
                          local function _42_(...)
                            if (... == true) then
                              return nil
                            else
                              local _0 = ...
                              return nil
                            end
                          end
                          return _42_(rm_file(index_path0))
                        else
                          local _0 = ...
                          return nil
                        end
                      end
                      return _41_(file_exists_3f(index_path0))
                    else
                      local _0 = ...
                      return nil
                    end
                  end
                  return _40_(path__3eindex_key(lua_path))
                end
              end
              return _21_(fin:read("a*"))
            else
              local _ = ...
              local function _47_(...)
                if (nil ~= ...) then
                  local index_path0 = ...
                  local function _48_(...)
                    if (... == true) then
                      local function _49_(...)
                        if (... == true) then
                          return nil
                        else
                          local _0 = ...
                          return nil
                        end
                      end
                      return _49_(rm_file(index_path0))
                    else
                      local _0 = ...
                      return nil
                    end
                  end
                  return _48_(file_exists_3f(index_path0))
                else
                  local _0 = ...
                  return nil
                end
              end
              return _47_(path__3eindex_key(lua_path))
            end
          end
          return _20_(io.open(index_path, "rb"))
        else
          local _ = ...
          local function _54_(...)
            if (nil ~= ...) then
              local index_path0 = ...
              local function _55_(...)
                if (... == true) then
                  local function _56_(...)
                    if (... == true) then
                      return nil
                    else
                      local _0 = ...
                      return nil
                    end
                  end
                  return _56_(rm_file(index_path0))
                else
                  local _0 = ...
                  return nil
                end
              end
              return _55_(file_exists_3f(index_path0))
            else
              local _0 = ...
              return nil
            end
          end
          return _54_(path__3eindex_key(lua_path))
        end
      end
      return _19_(file_exists_3f(index_path))
    else
      local _ = ...
      local function _61_(...)
        if (nil ~= ...) then
          local index_path = ...
          local function _62_(...)
            if (... == true) then
              local function _63_(...)
                if (... == true) then
                  return nil
                else
                  local _0 = ...
                  return nil
                end
              end
              return _63_(rm_file(index_path))
            else
              local _0 = ...
              return nil
            end
          end
          return _62_(file_exists_3f(index_path))
        else
          local _0 = ...
          return nil
        end
      end
      return _61_(path__3eindex_key(lua_path))
    end
  end
  return _18_(path__3eindex_key(lua_path))
end
local function fetch(lua_path)
  local case_68_, case_69_ = load(lua_path)
  if (nil ~= case_68_) then
    local record = case_68_
    local and_70_ = (nil ~= record)
    if and_70_ then
      local record0 = record
      and_70_ = module_3f(record0)
    end
    if and_70_ then
      local record0 = record
      return record0
    else
      local and_72_ = (nil ~= record)
      if and_72_ then
        local record0 = record
        and_72_ = runtime_3f(record0)
      end
      if and_72_ then
        local record0 = record
        return record0
      else
        local _ = record
        return nil, fmt("Could not load record, unknown type. Record: %s", vim.inspect(record))
      end
    end
  elseif ((case_68_ == false) and (nil ~= case_69_)) then
    local e = case_69_
    return nil
  else
    local _ = case_68_
    return nil
  end
end
local function save(record)
  local function _76_(...)
    local case_77_, case_78_ = ...
    if (case_77_ == true) then
      local function _79_(...)
        local case_80_, case_81_ = ...
        if ((_G.type(case_80_) == "table") and (nil ~= case_80_["lua-path"])) then
          local lua_path = case_80_["lua-path"]
          local function _82_(...)
            local case_83_, case_84_ = ...
            if ((_G.type(case_83_) == "table") and (nil ~= case_83_.mtime) and (nil ~= case_83_.size)) then
              local mtime = case_83_.mtime
              local size = case_83_.size
              local function _85_(...)
                local case_86_, case_87_ = ...
                if (nil ~= case_86_) then
                  local record0 = case_86_
                  local function _88_(...)
                    local case_89_, case_90_ = ...
                    if (case_89_ == true) then
                      local function _91_(...)
                        local case_92_, case_93_ = ...
                        if ((case_92_ == true) and (nil ~= case_93_)) then
                          local mpacked = case_93_
                          local function _94_(...)
                            local case_95_, case_96_ = ...
                            if (nil ~= case_95_) then
                              local index_path = case_95_
                              local function _97_(...)
                                local case_98_, case_99_ = ...
                                if (nil ~= case_98_) then
                                  local fout = case_98_
                                  local function _100_(...)
                                    local case_101_, case_102_ = ...
                                    if (case_101_ == true) then
                                      local function _103_(...)
                                        local case_104_, case_105_ = ...
                                        if (case_104_ == true) then
                                          return record0
                                        elseif ((case_104_ == false) and (nil ~= case_105_)) then
                                          local e = case_105_
                                          return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                        elseif ((case_104_ == nil) and (nil ~= case_105_)) then
                                          local e = case_105_
                                          return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                        else
                                          local _3fe = case_104_
                                          return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                                        end
                                      end
                                      return _103_(fout:close())
                                    elseif ((case_101_ == false) and (nil ~= case_102_)) then
                                      local e = case_102_
                                      return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                    elseif ((case_101_ == nil) and (nil ~= case_102_)) then
                                      local e = case_102_
                                      return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                    else
                                      local _3fe = case_101_
                                      return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                                    end
                                  end
                                  return _100_(fout:write(mpacked))
                                elseif ((case_98_ == false) and (nil ~= case_99_)) then
                                  local e = case_99_
                                  return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                elseif ((case_98_ == nil) and (nil ~= case_99_)) then
                                  local e = case_99_
                                  return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                                else
                                  local _3fe = case_98_
                                  return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                                end
                              end
                              return _97_(io.open(index_path, "wb"))
                            elseif ((case_95_ == false) and (nil ~= case_96_)) then
                              local e = case_96_
                              return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                            elseif ((case_95_ == nil) and (nil ~= case_96_)) then
                              local e = case_96_
                              return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                            else
                              local _3fe = case_95_
                              return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                            end
                          end
                          return _94_(path__3eindex_key(lua_path))
                        elseif ((case_92_ == false) and (nil ~= case_93_)) then
                          local e = case_93_
                          return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                        elseif ((case_92_ == nil) and (nil ~= case_93_)) then
                          local e = case_93_
                          return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                        else
                          local _3fe = case_92_
                          return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                        end
                      end
                      return _91_(pcall(vim.mpack.encode, {version = INDEX_VERSION, data = record0}))
                    elseif ((case_89_ == false) and (nil ~= case_90_)) then
                      local e = case_90_
                      return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                    elseif ((case_89_ == nil) and (nil ~= case_90_)) then
                      local e = case_90_
                      return error(string.format("Could not save record for %s\nReason: %s", record0["lua-path"], e))
                    else
                      local _3fe = case_89_
                      return error(string.format("unknown error when saving record %s %s", vim.inspect(record0), vim.inspect(_3fe)))
                    end
                  end
                  return _88_(make_path(INDEX_ROOT_PATH))
                elseif ((case_86_ == false) and (nil ~= case_87_)) then
                  local e = case_87_
                  return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
                elseif ((case_86_ == nil) and (nil ~= case_87_)) then
                  local e = case_87_
                  return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
                else
                  local _3fe = case_86_
                  return error(string.format("unknown error when saving record %s %s", vim.inspect(record), vim.inspect(_3fe)))
                end
              end
              local function _113_(...)
                record["lua-path-mtime-at-save"] = mtime
                record["lua-path-size-at-save"] = size
                return record
              end
              return _85_(_113_(...))
            elseif ((case_83_ == false) and (nil ~= case_84_)) then
              local e = case_84_
              return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
            elseif ((case_83_ == nil) and (nil ~= case_84_)) then
              local e = case_84_
              return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
            else
              local _3fe = case_83_
              return error(string.format("unknown error when saving record %s %s", vim.inspect(record), vim.inspect(_3fe)))
            end
          end
          return _82_(file_stat(lua_path))
        elseif ((case_80_ == false) and (nil ~= case_81_)) then
          local e = case_81_
          return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
        elseif ((case_80_ == nil) and (nil ~= case_81_)) then
          local e = case_81_
          return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
        else
          local _3fe = case_80_
          return error(string.format("unknown error when saving record %s %s", vim.inspect(record), vim.inspect(_3fe)))
        end
      end
      return _79_(record)
    elseif ((case_77_ == false) and (nil ~= case_78_)) then
      local e = case_78_
      return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
    elseif ((case_77_ == nil) and (nil ~= case_78_)) then
      local e = case_78_
      return error(string.format("Could not save record for %s\nReason: %s", record["lua-path"], e))
    else
      local _3fe = case_77_
      return error(string.format("unknown error when saving record %s %s", vim.inspect(record), vim.inspect(_3fe)))
    end
  end
  return _76_((module_3f(record) or runtime_3f(record)))
end
local function drop(record)
  if (nil == record) then
    _G.error("Missing argument record on fnl/hotpot/loader/record.fnl:108", 2)
  else
  end
  local function _118_(...)
    local case_119_, case_120_ = ...
    if (nil ~= case_119_) then
      local index_key = case_119_
      local function _121_(...)
        local case_122_, case_123_ = ...
        if (case_122_ == true) then
          return true
        elseif ((case_122_ == false) and (nil ~= case_123_)) then
          local e = case_123_
          return error(fmt("Could not drop index at %s\n%s", record["lua-path"], e))
        else
          return nil
        end
      end
      return _121_(rm_file(index_key))
    elseif ((case_119_ == false) and (nil ~= case_120_)) then
      local e = case_120_
      return error(fmt("Could not drop index at %s\n%s", record["lua-path"], e))
    else
      return nil
    end
  end
  return _118_(path__3eindex_key(record["lua-path"]))
end
local function new(type, modname, src_path, _3fopts)
  if (nil == src_path) then
    _G.error("Missing argument src-path on fnl/hotpot/loader/record.fnl:117", 2)
  else
  end
  if (nil == modname) then
    _G.error("Missing argument modname on fnl/hotpot/loader/record.fnl:117", 2)
  else
  end
  if (nil == type) then
    _G.error("Missing argument type on fnl/hotpot/loader/record.fnl:117", 2)
  else
  end
  local module
  do
    local case_129_, case_130_ = type
    if (case_129_ == RECORD_TYPE_MODULE) then
      module = "hotpot.loader.record.module"
    elseif (case_129_ == RECORD_TYPE_RUNTIME) then
      module = "hotpot.loader.record.runtime"
    else
      local _ = case_129_
      module = error(string.format("Could not create record, unknown type: %s at %s", type, src_path))
    end
  end
  local _let_132_ = require(module)
  local new_type = _let_132_.new
  local src_path0 = vim.fs.normalize(src_path)
  local modname0 = string.gsub(modname, "%.%.+", ".")
  local record = new_type(modname0, src_path0, _3fopts)
  return vim.tbl_extend("force", record, {type = type, ["lua-path-mtime-at-save"] = 0, ["lua-path-size-at-save"] = 0, files = {{path = src_path0, mtime = {sec = 0, nsec = 0}, size = 0}}})
end
local function set_files(record, files)
  if (nil == files) then
    _G.error("Missing argument files on fnl/hotpot/loader/record.fnl:135", 2)
  else
  end
  if (nil == record) then
    _G.error("Missing argument record on fnl/hotpot/loader/record.fnl:135", 2)
  else
  end
  local files0
  do
    table.insert(files, 1, record["src-path"])
    files0 = files
  end
  local file_stats
  do
    local tbl_26_ = {}
    local i_27_ = 0
    for _, path in ipairs(files0) do
      local val_28_
      do
        local _let_135_ = file_stat(path)
        local mtime = _let_135_.mtime
        local size = _let_135_.size
        val_28_ = {path = path, mtime = mtime, size = size}
      end
      if (nil ~= val_28_) then
        i_27_ = (i_27_ + 1)
        tbl_26_[i_27_] = val_28_
      else
      end
    end
    file_stats = tbl_26_
  end
  record["files"] = file_stats
  return record
end
local function _137_(...)
  return new(RECORD_TYPE_MODULE, ...)
end
local function _138_(...)
  return new(RECORD_TYPE_RUNTIME, ...)
end
return {save = save, fetch = fetch, drop = drop, ["new-module"] = _137_, ["new-runtime"] = _138_, ["set-files"] = set_files}