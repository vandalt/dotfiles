-- Custom fold expression for comment headers with equal signs
-- Matches patterns like: -- something ====

local M = {}

function M.foldexpr(lnum)
  lnum = lnum or vim.v.lnum
  local line = vim.fn.getline(lnum)
  local next_line = vim.fn.getline(lnum + 1)

  -- Match lines like: -- something ====(4 or more equal signs)
  if line:match("^%s*%-%-%s+.+====+%s*$") then
    return ">1"
  end

  -- If current line is empty and next line is a fold start, keep it visible
  if line:match("^%s*$") and next_line:match("^%s*%-%-%s+.+====+%s*$") then
    return "0"
  end

  -- If next line is a fold start, end the current fold
  if next_line:match("^%s*%-%-%s+.+====+%s*$") then
    return "<1"
  end

  return "="
end

return M
