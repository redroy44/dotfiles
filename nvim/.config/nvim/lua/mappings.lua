
-- Leader key
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", {noremap = true})
vim.g.mapleader = " "

-- Quickfix list
vim.api.nvim_set_keymap("n", "<C-]>", ":cnext<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-[>", ":cprev<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-\\>", ":clist<CR>", {noremap = true})

-- Line transform using 'Alt'
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", {noremap = true})
vim.api.nvim_set_keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", {noremap = true})
vim.api.nvim_set_keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", {noremap = true})
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", {noremap = true})
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", {noremap = true})

-- Tab navigation
vim.api.nvim_set_keymap("n", "<Leader><Esc>", ":bd<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>]", ":bnext<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>[", ":bprev<CR>", {noremap = true})

-- Window navigation
vim.api.nvim_set_keymap("n", "<C-h>", ":wincmd h<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-j>", ":wincmd j<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-k>", ":wincmd k<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-l>", ":wincmd l<CR>", {noremap = true})

-- Clear search result
vim.api.nvim_set_keymap("n", "<C-n>", ":set hlsearch!<CR>", {noremap = true})

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
	  options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Mappings.
local opts = {noremap = true, silent = true}

-- See `:help vim.lsp.*` for documentation on any of the below functions
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
map("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
map("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
map("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
map("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
map("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
map("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
map("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)
map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)