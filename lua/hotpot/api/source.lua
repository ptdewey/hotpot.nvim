local function split_path(path)
  local sep = string.sub(package.config, 1, 1)
  local tbl_26_ = {}
  local i_27_ = 0
  for v in string.gmatch(path, ("[^" .. sep .. "]+")) do
    local val_28_ = v
    if (nil ~= val_28_) then
      i_27_ = (i_27_ + 1)
      tbl_26_[i_27_] = val_28_
    else
    end
  end
  return tbl_26_
end
local function find_module_name_parts(path_parts, acc)
  local head = path_parts[1]
  local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(path_parts, 2)
  local case_2_, case_3_ = head, #rest
  if ((case_2_ == "init.fnl") and (case_3_ == 0)) then
    return acc
  elseif ((nil ~= case_2_) and (case_3_ == 0)) then
    local file = case_2_
    local last = string.gsub(file, "%.fnl$", "")
    table.insert(acc, last)
    return acc
  elseif ((nil ~= case_2_) and true) then
    local dir = case_2_
    local _ = case_3_
    table.insert(acc, dir)
    return find_module_name_parts(rest, acc)
  else
    return nil
  end
end
local function find_fnl_folder(path_parts)
  local head = path_parts[1]
  local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(path_parts, 2)
  if (head == nil) then
    return nil
  elseif (head == "fnl") then
    return find_module_name_parts(rest, {})
  elseif (nil ~= head) then
    local other = head
    return find_fnl_folder(rest)
  else
    return nil
  end
end
local function guess_module_name(full_path)
  local path = split_path(full_path)
  local mod = find_fnl_folder(path)
  if (mod == nil) then
    local modname = nil
    return modname
  elseif (nil ~= mod) then
    local list = mod
    local modname = table.concat(list, ".")
    return modname
  else
    return nil
  end
end
local function source_file(full_path)
  local modname = guess_module_name(full_path)
  if (modname == nil) then
    return print(("could not find module path for require " .. "command (not descendent of a 'fnl' dir?)"))
  elseif (nil ~= modname) then
    local any = modname
    package.loaded[modname] = nil
    return require(modname)
  else
    return nil
  end
end
return {source = source_file}