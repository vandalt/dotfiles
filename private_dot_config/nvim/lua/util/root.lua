-- Slightly modified version of LazyVim's root module
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/root.lua
local M = {}

-- Normalize a path by replacing ~ with the full home path,
-- using forward slash as separator and removing trailing separators
---@param path string
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home and (home:sub(-1) == "\\" or home:sub(-1) == "/") then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

M.detectors = {}

-- Detect root based on cwd
function M.detectors.cwd() return { vim.uv.cwd() } end

-- Path to the current buffer
---@param buf integer
function M.bufpath(buf) return M.realpath(vim.api.nvim_buf_get_name(assert(buf))) end

-- Detect root based on LSP 
---@param buf integer
function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  local clients = vim.lsp.get_clients({ bufnr = buf })
  clients = vim.tbl_filter(
    function(client) return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name) end,
    clients
  ) --[[@as vim.lsp.Client[] ]]
  for _, client in pairs(clients) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
    if client.root_dir then
      roots[#roots + 1] = client.root_dir
    end
  end
  return vim.tbl_filter(function(path)
    path = M.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param buf integer
---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
      if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
        return true
      end
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

---@type table<number, string>
M.cache = {}

---@class Root
---@field paths string[]
---@field spec RootSpec

---@alias RootFn fun(buf: number): (string|string[])

---@alias RootSpec string|string[]|RootFn

---@type RootSpec[]
M.spec = { { ".git", "lua" }, "lsp", "cwd" }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {buf?:number}
---@return string|nil
M.get = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false, buf = buf })
    ---@diagnostic disable-next-line: cast-local-type
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  return ret
end

---@param opts? { buf?: number, spec?: RootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type Root[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b) return #a > #b end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.fn.has("win32") == 0 and vim.uv.fs_realpath(path) or path
  return M.norm(path)
end

---@param spec RootSpec
---@return RootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf) return M.detectors.pattern(buf, spec) end
end

return M
