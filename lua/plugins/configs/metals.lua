local M = {}

M.config = function()
  local metals_config = require('metals').bare_config()
  metals_config.init_options.statusBarProvider = 'off'
  require('metals').initialize_or_attach(metals_config)
end

return M
