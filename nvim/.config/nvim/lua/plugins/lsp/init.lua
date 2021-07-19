require("lspinstall").setup() -- important

local nvim_lsp = require("lspconfig")

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- local on_attach = function(_, bufnr)
--   local function buf_set_keymap(...)
--     vim.api.nvim_buf_set_keymap(bufnr, ...)
--   end
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end

--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

--   -- Mappings.
--   local opts = {noremap = true, silent = true}

--   -- -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
--   buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
--   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
--   buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
--   buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
--   buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
--   buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
--   buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
--   buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
--   buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
--   buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
--   buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
--   buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
--   buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
--   buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
--   buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)
--   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)

--   vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
--   print("LSP Attached.")
-- end

-- local servers = require "lspinstall".installed_servers()

-- for _, lsp in pairs(servers) do
--   nvim_lsp[lsp].setup {on_attach = on_attach}
-- end