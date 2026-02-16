local function get_highlight()
  local function get_sel_start(mode)
    local case_1_ = {mode, vim.fn.getpos("v")}
    if ((case_1_[1] == "v") and ((_G.type(case_1_[2]) == "table") and true and (nil ~= case_1_[2][2]) and (nil ~= case_1_[2][3]) and true)) then
      local _buf = case_1_[2][1]
      local line = case_1_[2][2]
      local col = case_1_[2][3]
      local _offset = case_1_[2][4]
      return {line, col}
    elseif ((case_1_[1] == "V") and ((_G.type(case_1_[2]) == "table") and true and (nil ~= case_1_[2][2]) and (nil ~= case_1_[2][3]) and true)) then
      local _buf = case_1_[2][1]
      local line = case_1_[2][2]
      local col = case_1_[2][3]
      local _offset = case_1_[2][4]
      return {line, 1}
    else
      local _ = case_1_
      return error("Tried to get selection while not in v or V mode")
    end
  end
  local function get_cur(mode)
    local case_3_ = {mode, vim.fn.getpos(".")}
    if ((case_3_[1] == "v") and ((_G.type(case_3_[2]) == "table") and true and (nil ~= case_3_[2][2]) and (nil ~= case_3_[2][3]) and true)) then
      local _buf = case_3_[2][1]
      local line = case_3_[2][2]
      local col = case_3_[2][3]
      local _offset = case_3_[2][4]
      return {line, col}
    elseif ((case_3_[1] == "V") and ((_G.type(case_3_[2]) == "table") and true and (nil ~= case_3_[2][2]) and (nil ~= case_3_[2][3]) and true)) then
      local _buf = case_3_[2][1]
      local line = case_3_[2][2]
      local col = case_3_[2][3]
      local _offset = case_3_[2][4]
      return {line, 2147483647}
    else
      local _ = case_3_
      return error("Tried to get selection while not in v or V mode")
    end
  end
  local _let_5_ = vim.api.nvim_get_mode()
  local mode = _let_5_.mode
  local sel_start_pos = get_sel_start(mode)
  local cur_pos = get_cur(mode)
  local start, stop
  do
    local case_6_ = {sel_start_pos, cur_pos}
    local and_7_ = ((_G.type(case_6_) == "table") and ((_G.type(case_6_[1]) == "table") and (nil ~= case_6_[1][1]) and (nil ~= case_6_[1][2])) and ((_G.type(case_6_[2]) == "table") and (nil ~= case_6_[2][1]) and (nil ~= case_6_[2][2])))
    if and_7_ then
      local sl = case_6_[1][1]
      local sc = case_6_[1][2]
      local cl = case_6_[2][1]
      local cc = case_6_[2][2]
      and_7_ = ((sl == cl) and (sc == cc))
    end
    if and_7_ then
      local sl = case_6_[1][1]
      local sc = case_6_[1][2]
      local cl = case_6_[2][1]
      local cc = case_6_[2][2]
      start, stop = {sl, sc}, {cl, cc}
    else
      local and_9_ = ((_G.type(case_6_) == "table") and ((_G.type(case_6_[1]) == "table") and (nil ~= case_6_[1][1]) and (nil ~= case_6_[1][2])) and ((_G.type(case_6_[2]) == "table") and (nil ~= case_6_[2][1]) and (nil ~= case_6_[2][2])))
      if and_9_ then
        local sl = case_6_[1][1]
        local sc = case_6_[1][2]
        local cl = case_6_[2][1]
        local cc = case_6_[2][2]
        and_9_ = ((sl == cl) and (sc < cc))
      end
      if and_9_ then
        local sl = case_6_[1][1]
        local sc = case_6_[1][2]
        local cl = case_6_[2][1]
        local cc = case_6_[2][2]
        start, stop = {sl, sc}, {cl, cc}
      else
        local and_11_ = ((_G.type(case_6_) == "table") and ((_G.type(case_6_[1]) == "table") and (nil ~= case_6_[1][1]) and (nil ~= case_6_[1][2])) and ((_G.type(case_6_[2]) == "table") and (nil ~= case_6_[2][1]) and (nil ~= case_6_[2][2])))
        if and_11_ then
          local sl = case_6_[1][1]
          local sc = case_6_[1][2]
          local cl = case_6_[2][1]
          local cc = case_6_[2][2]
          and_11_ = ((sl == cl) and (cc < sc))
        end
        if and_11_ then
          local sl = case_6_[1][1]
          local sc = case_6_[1][2]
          local cl = case_6_[2][1]
          local cc = case_6_[2][2]
          start, stop = {cl, cc}, {sl, sc}
        else
          local and_13_ = ((_G.type(case_6_) == "table") and ((_G.type(case_6_[1]) == "table") and (nil ~= case_6_[1][1]) and (nil ~= case_6_[1][2])) and ((_G.type(case_6_[2]) == "table") and (nil ~= case_6_[2][1]) and (nil ~= case_6_[2][2])))
          if and_13_ then
            local sl = case_6_[1][1]
            local sc = case_6_[1][2]
            local cl = case_6_[2][1]
            local cc = case_6_[2][2]
            and_13_ = (sl < cl)
          end
          if and_13_ then
            local sl = case_6_[1][1]
            local sc = case_6_[1][2]
            local cl = case_6_[2][1]
            local cc = case_6_[2][2]
            start, stop = {sl, sc}, {cl, cc}
          else
            local and_15_ = ((_G.type(case_6_) == "table") and ((_G.type(case_6_[1]) == "table") and (nil ~= case_6_[1][1]) and (nil ~= case_6_[1][2])) and ((_G.type(case_6_[2]) == "table") and (nil ~= case_6_[2][1]) and (nil ~= case_6_[2][2])))
            if and_15_ then
              local sl = case_6_[1][1]
              local sc = case_6_[1][2]
              local cl = case_6_[2][1]
              local cc = case_6_[2][2]
              and_15_ = (cl < sl)
            end
            if and_15_ then
              local sl = case_6_[1][1]
              local sc = case_6_[1][2]
              local cl = case_6_[2][1]
              local cc = case_6_[2][2]
              start, stop = {cl, cc}, {sl, sc}
            else
              local _ = case_6_
              start, stop = error(string.format("unhandled selection-case :sel-start %s :cur-pos %s", vim.inspect(sel_start_pos), vim.inspect(cur_pos)))
            end
          end
        end
      end
    end
  end
  local start0, stop0
  do
    local case_18_, case_19_, case_20_ = mode, start, stop
    if ((case_18_ == "v") and (case_19_ == start) and (case_20_ == stop)) then
      start0, stop0 = start, stop
    elseif ((case_18_ == "V") and ((_G.type(case_19_) == "table") and (nil ~= case_19_[1]) and true) and ((_G.type(case_20_) == "table") and (nil ~= case_20_[1]) and true)) then
      local start_line = case_19_[1]
      local _ = case_19_[2]
      local stop_line = case_20_[1]
      local _0 = case_20_[2]
      local len
      local function _21_(_241)
        return _241[1]
      end
      len = #_21_(vim.api.nvim_buf_get_lines(0, (stop_line - 1), stop_line, true))
      start0, stop0 = {start_line, 1}, {stop_line, len}
    else
      start0, stop0 = nil
    end
  end
  return start0, stop0
end
local function get_range(buf, start, stop)
  assert(buf, "get-range missing buf arg")
  assert(start, "get-range missing start arg")
  assert(stop, "get-range missing stop arg")
  local lines
  do
    local case_23_, case_24_ = start, stop
    if (((_G.type(case_23_) == "table") and (nil ~= case_23_[1]) and (nil ~= case_23_[2])) and ((_G.type(case_24_) == "table") and (nil ~= case_24_[1]) and (nil ~= case_24_[2]))) then
      local start_line = case_23_[1]
      local start_col = case_23_[2]
      local stop_line = case_24_[1]
      local stop_col = case_24_[2]
      lines = vim.api.nvim_buf_get_text(buf, (start_line - 1), (start_col - 1), (stop_line - 1), stop_col, {})
    elseif ((nil ~= case_23_) and (nil ~= case_24_)) then
      local start_line = case_23_
      local stop_line = case_24_
      lines = vim.api.nvim_buf_get_lines(buf, (start_line - 1), stop_line, true)
    else
      lines = nil
    end
  end
  return table.concat(lines, "\n")
end
local function get_selection()
  local start, stop = get_highlight()
  return get_range(0, start, stop)
end
local function get_buf(buf)
  return get_range(buf, 1, -1)
end
return {["get-range"] = get_range, ["get-selection"] = get_selection, ["get-buf"] = get_buf, ["get-highlight"] = get_highlight}