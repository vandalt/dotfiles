-- This config is designed for Lua's activity around Neovim.
return {
  on_attach = function(client, buf_id)
    -- Reduce very long list of triggers for better 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }

    -- Use this function to define buffer-local mappings and behavior that depend
    -- on attached client or only makes sense if there is language server attached.
  end,
  -- LuaLS Structure of these settings comes from LuaLS, not Neovim
}
