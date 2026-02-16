local function eval_operator()
  local _let_1_ = require("hotpot.api.eval")
  local eval_range = _let_1_["eval-range"]
  local start = vim.api.nvim_buf_get_mark(0, "[")
  local stop = vim.api.nvim_buf_get_mark(0, "]")
  local case_2_, case_3_ = eval_range(0, start, stop)
  if ((case_2_ == false) and (nil ~= case_3_)) then
    local err = case_3_
    return error(err)
  else
    return nil
  end
end
local function eval_operator_bang()
  vim.go.operatorfunc = "v:lua.require'hotpot.api.command'.eval_operator"
  return vim.api.nvim_feedkeys("g@", "n", false)
end
local function fnl(start, stop, code, range_count)
  local _let_5_ = require("hotpot.api.eval")
  local eval_range = _let_5_["eval-range"]
  local eval_string = _let_5_["eval-string"]
  local _let_6_ = require("hotpot.fennel")
  local view = _let_6_.view
  local print_result
  local function _7_(_241)
    local _8_
    do
      local tbl_26_ = {}
      local i_27_ = 0
      for _, v in ipairs(_241) do
        local val_28_ = view(v)
        if (nil ~= val_28_) then
          i_27_ = (i_27_ + 1)
          tbl_26_[i_27_] = val_28_
        else
        end
      end
      _8_ = tbl_26_
    end
    return print(table.concat(_8_, ", "))
  end
  print_result = _7_
  local eval
  do
    local case_10_ = {(2 == range_count), code}
    if ((case_10_[1] == true) and (case_10_[2] == "=")) then
      local function _11_()
        local case_12_ = {eval_range(0, start, stop)}
        if (case_12_[1] == true) then
          local rest = {select(2, (table.unpack or _G.unpack)(case_12_))}
          return print_result(rest)
        elseif ((case_12_[1] == false) and (nil ~= case_12_[2])) then
          local e = case_12_[2]
          return false, e
        else
          return nil
        end
      end
      eval = _11_
    elseif ((case_10_[1] == true) and (case_10_[2] == "")) then
      local function _14_()
        return eval_range(0, start, stop)
      end
      eval = _14_
    else
      local and_15_ = ((_G.type(case_10_) == "table") and true and (case_10_[2] == code))
      if and_15_ then
        local _ = case_10_[1]
        and_15_ = ("=" == string.sub(code, 1, 1))
      end
      if and_15_ then
        local _ = case_10_[1]
        local function _17_()
          local case_18_ = {eval_string(string.sub(code, 2, -1))}
          if (case_18_[1] == true) then
            local rest = {select(2, (table.unpack or _G.unpack)(case_18_))}
            return print_result(rest)
          elseif ((case_18_[1] == false) and (nil ~= case_18_[2])) then
            local e = case_18_[2]
            return false, e
          else
            return nil
          end
        end
        eval = _17_
      elseif (true and (case_10_[2] == code)) then
        local _ = case_10_[1]
        local function _20_()
          return eval_string(code)
        end
        eval = _20_
      else
        eval = nil
      end
    end
  end
  local case_22_, case_23_ = eval()
  if ((case_22_ == false) and (nil ~= case_23_)) then
    local err = case_23_
    return error(err)
  else
    return nil
  end
end
local function fnlfile(file)
  local _let_25_ = require("hotpot.api.eval")
  local eval_file = _let_25_["eval-file"]
  local case_26_, case_27_ = eval_file(file)
  if ((case_26_ == false) and (nil ~= case_27_)) then
    local err = case_27_
    return error(err)
  else
    return nil
  end
end
local function fnldo(start, stop, code)
  assert((code and (code ~= "")), "Fnldo: missing expression to execute!")
  local _let_29_ = require("hotpot.fennel")
  local eval = _let_29_.eval
  local _let_30_ = require("hotpot.runtime")
  local traceback = _let_30_.traceback
  local codestr = ("(fn [line linenr] " .. code .. ")")
  local func
  do
    local case_31_, case_32_
    local function _33_()
      return eval(codestr, {filename = "hotpot-fnldo"})
    end
    case_31_, case_32_ = xpcall(_33_, traceback)
    if ((case_31_ == true) and (nil ~= case_32_)) then
      local func0 = case_32_
      func = func0
    elseif ((case_31_ == false) and (nil ~= case_32_)) then
      local err = case_32_
      func = error(err)
    else
      func = nil
    end
  end
  for i = start, stop do
    local line = vim.api.nvim_buf_get_lines(0, (i - 1), i, false)[1]
    vim.api.nvim_buf_set_lines(0, (i - 1), i, false, {func((line or ""), i)})
  end
  return nil
end
return {["eval-operator"] = eval_operator, eval_operator = eval_operator, ["eval-operator-bang"] = eval_operator_bang, fnl = fnl, fnlfile = fnlfile, fnldo = fnldo}