local fmt = string.format
local SIGIL_FILE = ".hotpot.lua"
local function load(path)
  local defaults = {schema = "hotpot/1", compiler = {}, build = false, clean = false}
  local valid_3f
  local function _1_(sigil)
    local case_2_
    do
      local tbl_26_ = {}
      local i_27_ = 0
      for key, _val in pairs(sigil) do
        local val_28_
        do
          local case_3_ = defaults[key]
          if (case_3_ == nil) then
            val_28_ = key
          else
            val_28_ = nil
          end
        end
        if (nil ~= val_28_) then
          i_27_ = (i_27_ + 1)
          tbl_26_[i_27_] = val_28_
        else
        end
      end
      case_2_ = tbl_26_
    end
    if ((_G.type(case_2_) == "table") and (case_2_[1] == nil)) then
      return true
    elseif (nil ~= case_2_) then
      local invalid_keys = case_2_
      local e = fmt("invalid keys in sigil %s: %s. The valid keys are: %s.", path, table.concat(invalid_keys, ", "), table.concat(vim.tbl_keys(defaults), ", "))
      return false, e
    else
      return nil
    end
  end
  valid_3f = _1_
  local function _7_(...)
    local case_8_, case_9_ = ...
    if (nil ~= case_8_) then
      local sigil_fn = case_8_
      local function _10_(...)
        local case_11_, case_12_ = ...
        local and_13_ = ((case_11_ == true) and (nil ~= case_12_))
        if and_13_ then
          local sigil = case_12_
          and_13_ = ("table" == type(sigil))
        end
        if and_13_ then
          local sigil = case_12_
          local function _15_(...)
            local case_16_, case_17_ = ...
            if (case_16_ == true) then
              return sigil
            elseif ((case_16_ == true) and (case_17_ == nil)) then
              vim.notify_once(fmt("Hotpot sigil was exists but returned nil, %s", path), vim.log.levels.WARN)
              return nil
            elseif ((case_16_ == true) and (nil ~= case_17_)) then
              local x = case_17_
              vim.notify(table.concat({"Hotpot sigil failed to load due to an input error.", fmt("Sigil path: %s", path), fmt("Sigil returned %s instead of table", type(x))}, "\n"), vim.log.levels.ERROR)
              return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
            elseif ((case_16_ == nil) and (nil ~= case_17_)) then
              local e = case_17_
              vim.notify(table.concat({"Hotpot sigil failed to load due to a syntax error.", fmt("Sigil path: %s", path), e}, "\n"), vim.log.levels.ERROR)
              return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
            elseif ((case_16_ == false) and (nil ~= case_17_)) then
              local e = case_17_
              vim.notify_once(fmt("hotpot sigil was invalid, %s\n%s", path, e), vim.log.levels.ERROR)
              return error("hotpot refusing to continue to avoid unintentional side effects.", 0)
            else
              return nil
            end
          end
          return _15_(valid_3f(sigil))
        elseif ((case_11_ == true) and (case_12_ == nil)) then
          vim.notify_once(fmt("Hotpot sigil was exists but returned nil, %s", path), vim.log.levels.WARN)
          return nil
        elseif ((case_11_ == true) and (nil ~= case_12_)) then
          local x = case_12_
          vim.notify(table.concat({"Hotpot sigil failed to load due to an input error.", fmt("Sigil path: %s", path), fmt("Sigil returned %s instead of table", type(x))}, "\n"), vim.log.levels.ERROR)
          return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
        elseif ((case_11_ == nil) and (nil ~= case_12_)) then
          local e = case_12_
          vim.notify(table.concat({"Hotpot sigil failed to load due to a syntax error.", fmt("Sigil path: %s", path), e}, "\n"), vim.log.levels.ERROR)
          return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
        elseif ((case_11_ == false) and (nil ~= case_12_)) then
          local e = case_12_
          vim.notify_once(fmt("hotpot sigil was invalid, %s\n%s", path, e), vim.log.levels.ERROR)
          return error("hotpot refusing to continue to avoid unintentional side effects.", 0)
        else
          return nil
        end
      end
      return _10_(pcall(sigil_fn))
    elseif ((case_8_ == true) and (case_9_ == nil)) then
      vim.notify_once(fmt("Hotpot sigil was exists but returned nil, %s", path), vim.log.levels.WARN)
      return nil
    elseif ((case_8_ == true) and (nil ~= case_9_)) then
      local x = case_9_
      vim.notify(table.concat({"Hotpot sigil failed to load due to an input error.", fmt("Sigil path: %s", path), fmt("Sigil returned %s instead of table", type(x))}, "\n"), vim.log.levels.ERROR)
      return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
    elseif ((case_8_ == nil) and (nil ~= case_9_)) then
      local e = case_9_
      vim.notify(table.concat({"Hotpot sigil failed to load due to a syntax error.", fmt("Sigil path: %s", path), e}, "\n"), vim.log.levels.ERROR)
      return error("Hotpot refusing to continue to avoid unintentional side effects.", 0)
    elseif ((case_8_ == false) and (nil ~= case_9_)) then
      local e = case_9_
      vim.notify_once(fmt("hotpot sigil was invalid, %s\n%s", path, e), vim.log.levels.ERROR)
      return error("hotpot refusing to continue to avoid unintentional side effects.", 0)
    else
      return nil
    end
  end
  return _7_(loadfile(path))
end
return {load = load, SIGIL_FILE = SIGIL_FILE}