local M = {}

function M.ai_whichkey()
  -- Function to add ai to which-key, inspired from LazyVim but smaller
  -- Could add more default text objects if I use them more
  local ret = { mode = { "o", "x" } }
  local objects = {
    { "j", desc = "jupyter IPython hydrogen cell" },
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "g", desc = "entire file" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }
  local groups = {a = "around", i = "inside"}
  for prefix, _ in pairs(groups) do
    for _, object in ipairs(objects) do
      ret[#ret+1] = { prefix .. object[1], desc = object.desc }
    end
  end
  require("which-key").add(ret)
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M.get_opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end


return M
