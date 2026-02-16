local _local_1_ = require("hotpot.common")
local table_3f = _local_1_["table?"]
local function_3f = _local_1_["function?"]
local boolean_3f = _local_1_["boolean?"]
local string_3f = _local_1_["string?"]
local nil_3f = _local_1_["nil?"]
local map = _local_1_.map
local reduce = _local_1_.reduce
local filter = _local_1_.filter
local any_3f = _local_1_["any?"]
local none_3f = _local_1_["none?"]
local uv = vim.loop
local M = {}
local automake_memo = {augroup = nil, ["attached-buffers"] = {}}
local function ns__3ems(ns)
  return math.floor((ns / 1000000))
end
local function merge_with_default_options(opts)
  if (nil == opts) then
    _G.error("Missing argument opts on fnl/hotpot/api/make.fnl:13", 2)
  else
  end
  local _let_3_ = require("hotpot.runtime")
  local default_config = _let_3_["default-config"]
  local compiler_options = vim.tbl_extend("keep", (opts.compiler or {}), default_config().compiler)
  local opts0 = vim.tbl_extend("keep", opts, {atomic = false, dryrun = false, force = false, verbose = false})
  opts0["compiler"] = compiler_options
  if opts0.dryrun then
    opts0.verbose = true
  else
  end
  return opts0
end
local function validate_spec(kind, spec)
  local case_5_
  do
    local ok = true
    for _, s in ipairs(spec) do
      if not (true == ok) then break end
      local and_6_ = ((_G.type(s) == "table") and (nil ~= s[1]) and (nil ~= s[2]))
      if and_6_ then
        local pat = s[1]
        local act = s[2]
        and_6_ = (string_3f(pat) and (boolean_3f(act) or function_3f(act)))
      end
      if and_6_ then
        local pat = s[1]
        local act = s[2]
        ok = true
      else
        local _0 = s
        ok = {false, string.format("Invalid pattern for %s: %s", kind, vim.inspect(s))}
      end
    end
    case_5_ = ok
  end
  if (case_5_ == true) then
    return true
  elseif ((_G.type(case_5_) == "table") and (case_5_[1] == false) and (nil ~= case_5_[2])) then
    local e = case_5_[2]
    return nil, e
  else
    return nil
  end
end
local function needs_compile_3f(src, dest)
  local _let_10_ = require("hotpot.fs")
  local file_missing_3f = _let_10_["file-missing?"]
  local file_stat = _let_10_["file-stat"]
  local or_11_ = file_missing_3f(dest)
  if not or_11_ then
    local _let_13_ = file_stat(src)
    local smtime = _let_13_.mtime
    local _let_14_ = file_stat(dest)
    local dmtime = _let_14_.mtime
    or_11_ = (dmtime.sec < smtime.sec)
  end
  return or_11_
end
local function find_compile_targets(root_dir, spec)
  local files = {}
  local begin_search_at = uv.hrtime()
  local split = {build = {}, ignore = {}, ["time-ns"] = nil}
  for _, _15_ in ipairs(spec) do
    local glob = _15_[1]
    local action = _15_[2]
    assert(string.match(glob, "%.fnlm?$"), string.format("build glob patterns must end in .fnl, got %s", glob))
    for _0, path in ipairs(vim.fn.globpath(root_dir, glob, true, true)) do
      local path0 = vim.fs.normalize(path)
      if (nil == files[path0]) then
        local case_16_ = {string.find(glob, "fnl/"), action}
        local and_17_ = ((_G.type(case_16_) == "table") and true and (nil ~= case_16_[2]))
        if and_17_ then
          local _1 = case_16_[1]
          local f = case_16_[2]
          and_17_ = function_3f(f)
        end
        if and_17_ then
          local _1 = case_16_[1]
          local f = case_16_[2]
          local case_19_ = f(path0)
          if (case_19_ == false) then
            files[path0] = false
          else
            local and_20_ = (nil ~= case_19_)
            if and_20_ then
              local dest_path = case_19_
              and_20_ = string_3f(dest_path)
            end
            if and_20_ then
              local dest_path = case_19_
              files[path0] = string.gsub(vim.fs.normalize(dest_path), "%.fnl$", ".lua")
            else
              local _3fsome = case_19_
              error(string.format("Invalid return value from build function: %s => %s", path0, type(_3fsome)))
            end
          end
        elseif (true and (case_16_[2] == false)) then
          local _1 = case_16_[1]
          files[path0] = false
        elseif ((case_16_[1] == 1) and (case_16_[2] == true)) then
          files[path0] = (root_dir .. "/lua/" .. string.sub(path0, (#root_dir + 6), -4) .. "lua")
        elseif (true and (case_16_[2] == true)) then
          local _1 = case_16_[1]
          files[path0] = (string.sub(path0, 1, -4) .. "lua")
        else
        end
      else
      end
    end
  end
  for path, action in pairs(files) do
    if action then
      table.insert(split.build, {src = path, dest = vim.fs.normalize(action)})
    else
      table.insert(split.ignore, {src = path})
    end
  end
  split["time-ns"] = (uv.hrtime() - begin_search_at)
  return split
end
local function find_clean_targets(root_dir, spec, compile_targets)
  local files = {}
  for _, _26_ in ipairs(spec) do
    local glob = _26_[1]
    local action = _26_[2]
    assert(string.match(glob, "%.lua$"), string.format("clean glob patterns must end in .lua, got %s", glob))
    for _0, path in ipairs(vim.fn.globpath(root_dir, glob, true, true)) do
      if (nil == files[path]) then
        files[vim.fs.normalize(path)] = action
      else
      end
    end
  end
  for _, _28_ in ipairs(compile_targets) do
    local dest = _28_.dest
    files[dest] = false
  end
  local tbl_26_ = {}
  local i_27_ = 0
  for path, action in pairs(files) do
    local val_28_
    if action then
      val_28_ = path
    else
      val_28_ = nil
    end
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  return tbl_26_
end
local function do_compile(compile_targets, compiler_options, root_dir)
  local _let_31_ = require("hotpot.lang.fennel.compiler")
  local compile_file = _let_31_["compile-file"]
  do
    local case_32_ = package.loaded
    if ((_G.type(case_32_) == "table") and (nil ~= case_32_["hotpot.fennel"])) then
      local fennel = case_32_["hotpot.fennel"]
      for k, _ in pairs(fennel["macro-loaded"]) do
        fennel["macro-loaded"][k] = nil
      end
    else
    end
  end
  local function _35_(_34_)
    local src = _34_.src
    local dest = _34_.dest
    local tmp_path = (vim.fn.tempname() .. ".lua")
    local relative_filename = string.sub(src, (2 + #root_dir))
    local begin_compile_at = uv.hrtime()
    local case_36_, case_37_
    local _38_
    do
      local tmp_9_ = compiler_options.modules
      tmp_9_["filename"] = relative_filename
      _38_ = tmp_9_
    end
    case_36_, case_37_ = compile_file(src, tmp_path, _38_, compiler_options.macros, compiler_options.preprocessor)
    if (case_36_ == true) then
      return {src = src, dest = dest, ["tmp-path"] = tmp_path, ["compiled?"] = true, ["time-ns"] = (uv.hrtime() - begin_compile_at)}
    elseif ((case_36_ == false) and (nil ~= case_37_)) then
      local e = case_37_
      return {src = src, dest = dest, ["time-ns"] = (uv.hrtime() - begin_compile_at), err = e, ["compiled?"] = false}
    else
      return nil
    end
  end
  return map(_35_, compile_targets)
end
local function report_compile_results(compile_results, _40_)
  local any_errors_3f = _40_["any-errors?"]
  local verbose_3f = _40_["verbose?"]
  local atomic_3f = _40_["atomic?"]
  local dry_run_3f = _40_["dry-run?"]
  local find_time_ns = _40_["find-time-ns"]
  local report = {}
  if dry_run_3f then
    table.insert(report, {"No changes were written to disk! Compiled with dryrun = true!\n", "DiagnosticWarn"})
  else
  end
  if (any_errors_3f and atomic_3f) then
    table.insert(report, {"No changes were written to disk! Compiled with atomic = true and some files had compilation errors!\n", "DiagnosticWarn"})
  else
  end
  local function _43_(_241)
    local compiled_3f = _241["compiled?"]
    local src = _241.src
    local dest = _241.dest
    local time_ns = _241["time-ns"]
    local function _44_()
      if _241["compiled?"] then
        return {"\226\152\145  ", "DiagnosticOK"}
      else
        return {"\226\152\146  ", "DiagnosticWarn"}
      end
    end
    local _let_45_ = _44_()
    local char = _let_45_[1]
    local level = _let_45_[2]
    table.insert(report, {string.format("%s%s\n", char, src), level})
    return table.insert(report, {string.format("-> %s (%sms)\n", dest, ns__3ems(time_ns)), level})
  end
  local function _47_(_46_)
    local compiled_3f = _46_["compiled?"]
    return (verbose_3f or not compiled_3f)
  end
  map(_43_, filter(_47_, compile_results))
  if verbose_3f then
    local function _49_(sum, _48_)
      local time_ns = _48_["time-ns"]
      return (sum + time_ns)
    end
    local function _51_(_50_)
      local compiled_3f = _50_["compiled?"]
      return compiled_3f
    end
    table.insert(report, {string.format("Disk: %sms Compile: %sms\n", ns__3ems(find_time_ns), ns__3ems(reduce(_49_, 0, filter(_51_, compile_results)))), "DiagnosticInfo"})
  else
  end
  local function _53_(_241)
    if ((_G.type(_241) == "table") and (nil ~= _241.err)) then
      local err = _241.err
      return table.insert(report, {err, "DiagnosticError"})
    else
      return nil
    end
  end
  map(_53_, compile_results)
  if (0 < #report) then
    vim.api.nvim_echo(report, true, {})
  else
  end
  return nil
end
local function do_build(opts, root_dir, build_spec)
  assert(validate_spec("build", build_spec))
  local root_dir0 = vim.fs.normalize(root_dir)
  local force_3f = opts.force
  local verbose_3f = opts.verbose
  local dry_run_3f = opts.dryrun
  local atomic_3f = opts.atomic
  local _let_56_ = require("hotpot.fs")
  local rm_file = _let_56_["rm-file"]
  local copy_file = _let_56_["copy-file"]
  local compiler_options = opts.compiler
  local _let_57_ = find_compile_targets(root_dir0, build_spec)
  local all_compile_targets = _let_57_.build
  local all_ignore_targets = _let_57_.ignore
  local find_time_ns = _let_57_["time-ns"]
  local force_3f0
  local or_58_ = force_3f
  if not or_58_ then
    local case_59_ = opts["infer-force-for-file"]
    if (nil ~= case_59_) then
      local file = case_59_
      local function _62_(_241)
        return (_241.src == file)
      end
      or_58_ = any_3f(_62_, all_ignore_targets)
    else
      local _ = case_59_
      or_58_ = false
    end
  end
  force_3f0 = or_58_
  local focused_compile_target
  local function _66_(_65_)
    local src = _65_.src
    local dest = _65_.dest
    return (force_3f0 or needs_compile_3f(src, dest))
  end
  focused_compile_target = filter(_66_, all_compile_targets)
  local compile_results = do_compile(focused_compile_target, compiler_options, root_dir0)
  local any_errors_3f
  local function _67_(_241)
    return not _241["compiled?"]
  end
  any_errors_3f = any_3f(_67_, compile_results)
  local function _69_(_68_)
    local tmp_path = _68_["tmp-path"]
    local dest = _68_.dest
    if tmp_path then
      if (not dry_run_3f and (not atomic_3f or not any_errors_3f)) then
        copy_file(tmp_path, dest)
      else
      end
      return rm_file(tmp_path)
    else
      return nil
    end
  end
  map(_69_, compile_results)
  report_compile_results(compile_results, {["any-errors?"] = any_errors_3f, ["dry-run?"] = dry_run_3f, ["verbose?"] = verbose_3f, ["atomic?"] = atomic_3f, ["find-time-ns"] = find_time_ns})
  local _return
  do
    local tbl_21_ = {}
    for _, _72_ in ipairs(all_compile_targets) do
      local src = _72_.src
      local dest = _72_.dest
      local k_22_, v_23_ = src, {src = src, dest = dest}
      if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
        tbl_21_[k_22_] = v_23_
      else
      end
    end
    _return = tbl_21_
  end
  local _return0
  do
    local tbl_21_ = _return
    for _, _74_ in ipairs(compile_results) do
      local src = _74_.src
      local compiled_3f = _74_["compiled?"]
      local err = _74_.err
      local k_22_, v_23_
      local function _75_()
        local tmp_9_ = _return[src]
        tmp_9_["compiled?"] = compiled_3f
        tmp_9_["err"] = err
        return tmp_9_
      end
      k_22_, v_23_ = src, _75_()
      if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
        tbl_21_[k_22_] = v_23_
      else
      end
    end
    _return0 = tbl_21_
  end
  local tbl_26_ = {}
  local i_27_ = 0
  for _, v in pairs(_return0) do
    local val_28_ = v
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  return tbl_26_
end
local function do_clean(clean_targets, opts)
  local _let_78_ = require("hotpot.fs")
  local rm_file = _let_78_["rm-file"]
  for _, file in ipairs(clean_targets) do
    local case_79_, case_80_ = rm_file(file)
    if (case_79_ == true) then
      vim.notify(string.format("rm %s", file), vim.log.levels.WARN)
    elseif ((case_79_ == false) and (nil ~= case_80_)) then
      local e = case_80_
      vim.notify(string.format("Could not clean file %s, %s", file, e), vim.log.levels.ERROR)
    else
    end
  end
  return nil
end
M.build = function(...)
  local case_82_ = {...}
  local and_83_ = ((_G.type(case_82_) == "table") and (nil ~= case_82_[1]) and (nil ~= case_82_[2]) and (case_82_[3] == nil))
  if and_83_ then
    local root = case_82_[1]
    local build_specs = case_82_[2]
    and_83_ = (string_3f(root) and table_3f(build_specs))
  end
  if and_83_ then
    local root = case_82_[1]
    local build_specs = case_82_[2]
    return do_build(merge_with_default_options({}), root, build_specs)
  else
    local and_85_ = ((_G.type(case_82_) == "table") and (nil ~= case_82_[1]) and (nil ~= case_82_[2]) and (nil ~= case_82_[3]) and (case_82_[4] == nil))
    if and_85_ then
      local root = case_82_[1]
      local opts = case_82_[2]
      local build_specs = case_82_[3]
      and_85_ = (string_3f(root) and table_3f(opts) and table_3f(build_specs))
    end
    if and_85_ then
      local root = case_82_[1]
      local opts = case_82_[2]
      local build_specs = case_82_[3]
      return do_build(merge_with_default_options(opts), root, build_specs)
    else
      local _ = case_82_
      return vim.notify(("The hotpot.api.make usage has changed, please see\n" .. ":h hotpot-cookbook-using-dot-hotpot\n" .. ":h hotpot.api.make\n" .. "Unfortunately it was not possible to support both options simultaneously :( sorry."), vim.log.levels.WARN)
    end
  end
end
M.check = function(...)
  return vim.notify(("The hotpot.api.make usage has changed, please see\n" .. ":h hotpot-cookbook-using-dot-hotpot\n" .. ":h hotpot.api.make\n" .. "Unfortunately it was not possible to support both options simultaneously :( sorry."), vim.log.levels.WARN)
end
do
  local function build_spec_or_default(given_spec)
    local default_spec = {{"fnl/**/*macro*.fnl", false}, {"fnl/**/*.fnlm", false}, {"fnl/**/*.fnl", true}}
    local function _88_()
      if (given_spec == true) then
        return {default_spec, {}}
      elseif ((_G.type(given_spec) == "table") and ((_G.type(given_spec[1]) == "table") and (given_spec[1][1] == nil)) and (given_spec[2] == nil)) then
        local opts = given_spec[1]
        return {default_spec, opts}
      elseif ((_G.type(given_spec) == "table") and ((_G.type(given_spec[1]) == "table") and (given_spec[1][1] == nil))) then
        local opts = given_spec[1]
        local spec = {select(2, (table.unpack or _G.unpack)(given_spec))}
        return {spec, opts}
      elseif (nil ~= given_spec) then
        local spec = given_spec
        return {spec, {}}
      else
        return nil
      end
    end
    local _let_89_ = _88_()
    local spec = _let_89_[1]
    local opts = _let_89_[2]
    return {["build-spec"] = spec, ["build-options"] = opts}
  end
  local function clean_spec_or_default(clean_spec)
    if (clean_spec == true) then
      return {{"lua/**/*.lua", true}}
    else
      local and_90_ = (nil ~= clean_spec)
      if and_90_ then
        local t = clean_spec
        and_90_ = table_3f(t)
      end
      if and_90_ then
        local t = clean_spec
        return t
      else
        return nil
      end
    end
  end
  local function handle_config(config, current_file, root_dir, _3fmanual_opts)
    if config.build then
      local function _93_(...)
        local case_94_, case_95_ = ...
        if ((_G.type(case_94_) == "table") and (nil ~= case_94_["build-spec"]) and (nil ~= case_94_["build-options"])) then
          local build_spec = case_94_["build-spec"]
          local build_options = case_94_["build-options"]
          local function _96_(...)
            local case_97_, case_98_ = ...
            if (nil ~= case_97_) then
              local build_options0 = case_97_
              local function _99_(...)
                local case_100_, case_101_ = ...
                if (case_100_ == true) then
                  local function _102_(...)
                    local case_103_, case_104_ = ...
                    if true then
                      local _ = case_103_
                      local function _105_(...)
                        local case_106_, case_107_ = ...
                        if true then
                          local _0 = case_106_
                          local function _108_(...)
                            local case_109_, case_110_ = ...
                            if (nil ~= case_109_) then
                              local compile_results = case_109_
                              local function _111_(...)
                                local case_112_, case_113_ = ...
                                if (nil ~= case_112_) then
                                  local any_errors_3f = case_112_
                                  if (config.clean and not build_options0.dryrun and (not build_options0.atomic or (build_options0.atomic and not any_errors_3f))) then
                                    local function _114_(...)
                                      local case_115_, case_116_ = ...
                                      if (nil ~= case_115_) then
                                        local clean_spec = case_115_
                                        local function _117_(...)
                                          local case_118_, case_119_ = ...
                                          if (case_118_ == true) then
                                            local function _120_(...)
                                              local case_121_, case_122_ = ...
                                              if (nil ~= case_121_) then
                                                local clean_targets = case_121_
                                                local function _123_(...)
                                                  local case_124_, case_125_ = ...
                                                  if true then
                                                    local _1 = case_124_
                                                    return compile_results
                                                  elseif ((case_124_ == nil) and (nil ~= case_125_)) then
                                                    local e = case_125_
                                                    return vim.notify(e, vim.log.levels.ERROR)
                                                  else
                                                    return nil
                                                  end
                                                end
                                                return _123_(do_clean(clean_targets, build_options0))
                                              elseif ((case_121_ == nil) and (nil ~= case_122_)) then
                                                local e = case_122_
                                                return vim.notify(e, vim.log.levels.ERROR)
                                              else
                                                return nil
                                              end
                                            end
                                            return _120_(find_clean_targets(root_dir, clean_spec, compile_results))
                                          elseif ((case_118_ == nil) and (nil ~= case_119_)) then
                                            local e = case_119_
                                            return vim.notify(e, vim.log.levels.ERROR)
                                          else
                                            return nil
                                          end
                                        end
                                        return _117_(validate_spec("clean", clean_spec))
                                      elseif ((case_115_ == nil) and (nil ~= case_116_)) then
                                        local e = case_116_
                                        return vim.notify(e, vim.log.levels.ERROR)
                                      else
                                        return nil
                                      end
                                    end
                                    return _114_(clean_spec_or_default(config.clean))
                                  else
                                    return compile_results
                                  end
                                elseif ((case_112_ == nil) and (nil ~= case_113_)) then
                                  local e = case_113_
                                  return vim.notify(e, vim.log.levels.ERROR)
                                else
                                  return nil
                                end
                              end
                              local function _132_(_241)
                                return _241["err?"]
                              end
                              return _111_(any_3f(_132_, compile_results))
                            elseif ((case_109_ == nil) and (nil ~= case_110_)) then
                              local e = case_110_
                              return vim.notify(e, vim.log.levels.ERROR)
                            else
                              return nil
                            end
                          end
                          return _108_(M.build(root_dir, build_options0, build_spec))
                        elseif ((case_106_ == nil) and (nil ~= case_107_)) then
                          local e = case_107_
                          return vim.notify(e, vim.log.levels.ERROR)
                        else
                          return nil
                        end
                      end
                      build_options0.compiler = config.compiler
                      return _105_(nil)
                    elseif ((case_103_ == nil) and (nil ~= case_104_)) then
                      local e = case_104_
                      return vim.notify(e, vim.log.levels.ERROR)
                    else
                      return nil
                    end
                  end
                  build_options0["infer-force-for-file"] = current_file
                  return _102_(nil)
                elseif ((case_100_ == nil) and (nil ~= case_101_)) then
                  local e = case_101_
                  return vim.notify(e, vim.log.levels.ERROR)
                else
                  return nil
                end
              end
              return _99_(validate_spec("build", build_spec))
            elseif ((case_97_ == nil) and (nil ~= case_98_)) then
              local e = case_98_
              return vim.notify(e, vim.log.levels.ERROR)
            else
              return nil
            end
          end
          local function _138_(...)
            if _3fmanual_opts then
              return vim.tbl_extend("force", build_options, _3fmanual_opts)
            else
              return build_options
            end
          end
          return _96_(_138_(...))
        elseif ((case_94_ == nil) and (nil ~= case_95_)) then
          local e = case_95_
          return vim.notify(e, vim.log.levels.ERROR)
        else
          return nil
        end
      end
      return _93_(build_spec_or_default(config.build))
    else
      return nil
    end
  end
  local function build(file_dir_or_dot_hotpot, _3fopts)
    local _let_141_ = require("hotpot.runtime")
    local lookup_local_config = _let_141_["lookup-local-config"]
    local loadfile_local_config = _let_141_["loadfile-local-config"]
    local query_path = vim.loop.fs_realpath(vim.fn.expand(vim.fs.normalize(file_dir_or_dot_hotpot)))
    local opts = vim.tbl_extend("keep", (_3fopts or {}), {force = true, verbose = true})
    if query_path then
      local case_142_ = lookup_local_config(query_path)
      if (nil ~= case_142_) then
        local config_path = case_142_
        local function _143_(...)
          if (nil ~= ...) then
            local config = ...
            local function _144_(...)
              if true then
                local _ = ...
                return handle_config(config, query_path, vim.fs.dirname(config_path), opts)
              else
                local __43_ = ...
                return ...
              end
            end
            local function _146_(...)
              if not config.build then
                config.build = true
                return nil
              else
                return nil
              end
            end
            return _144_(_146_(...))
          else
            local __43_ = ...
            return ...
          end
        end
        return _143_(loadfile_local_config(config_path))
      elseif (case_142_ == nil) then
        return vim.notify(string.format("No .hotpot.lua file found near %s", query_path), vim.log.levels.ERROR)
      else
        return nil
      end
    else
      return vim.notify(string.format("Unable to build, no file or directory found at %s.", file_dir_or_dot_hotpot), vim.log.levels.ERROR)
    end
  end
  local function attach(buf)
    if not automake_memo["attached-buffers"][buf] then
      automake_memo["attached-buffers"][buf] = true
      local function _150_()
        local _let_151_ = require("hotpot.runtime")
        local lookup_local_config = _let_151_["lookup-local-config"]
        local loadfile_local_config = _let_151_["loadfile-local-config"]
        local full_path_current_file = vim.fs.normalize(vim.fn.expand("<afile>:p"))
        local function _152_(...)
          if (nil ~= ...) then
            local config_path = ...
            local function _153_(...)
              if (nil ~= ...) then
                local config = ...
                return handle_config(config, full_path_current_file, vim.fs.dirname(config_path))
              else
                local __43_ = ...
                return ...
              end
            end
            return _153_(loadfile_local_config(config_path))
          else
            local __43_ = ...
            return ...
          end
        end
        _152_(lookup_local_config(full_path_current_file))
        return nil
      end
      return vim.api.nvim_create_autocmd("BufWritePost", {buffer = buf, desc = ("hotpot-check-dot-hotpot-dot-lua-for-" .. buf), callback = _150_})
    else
      return nil
    end
  end
  local function enable()
    if not automake_memo.augroup then
      automake_memo.augroup = vim.api.nvim_create_augroup("hotpot-automake-enabled", {clear = true})
      local function _157_(event)
        if ((_G.type(event) == "table") and (event.match == "fennel") and (nil ~= event.buf)) then
          local buf = event.buf
          attach(buf)
        else
        end
        return nil
      end
      return vim.api.nvim_create_autocmd("FileType", {group = automake_memo.augroup, pattern = "fennel", desc = "Hotpot automake auto-attach", callback = _157_})
    else
      return nil
    end
  end
  M.auto = {enable = enable, build = build}
end
return M