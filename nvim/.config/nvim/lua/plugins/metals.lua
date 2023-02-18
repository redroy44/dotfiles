local M = {}

M.setup = function()

  local metals_config = require('metals').bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    excludedPackages = {
      'akka.actor.typed.javadsl',
      'com.github.swagger.akka.javadsl'
    }
  }

  -- Mappings
vim.keymap.set('n', '<space>t', function()
  require("dap").repl.toggle()
end, { noremap = true, silent = true })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  metals_config.capabilities = capabilities

  metals_config.on_attach = function(client, bufnr)
    require('lsp.opts').on_attach(client, bufnr)
    require('metals').setup_dap()
  end

  local dap = require('dap')
  dap.defaults.fallback.force_external_terminal = true

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run",
      metals = {
        runType = "run",
        -- args = { "firstArg", "secondArg", "thirdArg" },
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metals = {
        runType = "testFile",
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }



  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require('metals').initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })

end

return M
