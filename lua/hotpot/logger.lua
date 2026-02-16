local M = {}
local PID = vim.fn.getpid()
local _2apath_2a = vim.fs.normalize(string.format("%s/%s", vim.fn.stdpath("log"), "hotpot.log"))
local function view(x)
  local case_1_, case_2_ = pcall(require, "fennel")
  if ((case_1_ == true) and ((_G.type(case_2_) == "table") and (nil ~= case_2_.view))) then
    local view0 = case_2_.view
    return view0(x)
  elseif ((case_1_ == false) and true) then
    local _ = case_2_
    return vim.inspect(x)
  else
    return nil
  end
end
local _2alog_fd_2a = nil
local function open(path)
  if not _2alog_fd_2a then
    local case_4_, case_5_ = io.open(path, "a")
    if (nil ~= case_4_) then
      local fd = case_4_
      fd:setvbuf("line")
      _2alog_fd_2a = fd
    elseif ((case_4_ == nil) and (nil ~= case_5_)) then
      local e = case_5_
      error(e)
    else
    end
  else
  end
  return _2alog_fd_2a
end
local function write(...)
  local fd = open(_2apath_2a())
  fd:write(...)
  return nil
end
local function expand_string(msg, ...)
  local vargs = {...}
  local n = select("#", ...)
  local details
  do
    local tbl_26_ = {}
    local i_27_ = 0
    for i = 1, n do
      local val_28_
      do
        local v = vargs[i]
        local case_8_ = type(v)
        if (case_8_ == "string") then
          val_28_ = v
        else
          local _ = case_8_
          val_28_ = view(v)
        end
      end
      if (nil ~= val_28_) then
        i_27_ = (i_27_ + 1)
        tbl_26_[i_27_] = val_28_
      else
      end
    end
    details = tbl_26_
  end
  return string.format(msg, unpack(details))
end
local function msg__3elogline(msg)
  return ("(" .. PID .. ") " .. os.date("%FT%T%z") .. ": " .. msg .. "\n")
end
M.path = function()
  return _2apath_2a
end
M.info = function(msg, ...)
  local msg0
  do
    local case_11_ = type(msg)
    if (case_11_ == "string") then
      msg0 = expand_string(msg, ...)
    else
      local _ = case_11_
      msg0 = view(msg)
    end
  end
  return write(msg__3elogline(msg0))
end
return M