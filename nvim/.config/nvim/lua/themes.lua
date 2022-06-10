-- Onedark
require("onedark").setup {
	style = 'cool'
}
require('onedark').load()

-- Lualine
require("lualine").setup {
	options = {
	    theme = 'onedark',
	    -- theme = "gruvbox-flat",
	    section_separators = {left = '', right = ''},
	    component_separators = {left = '', right = ''},
	    icons_enabled = true
	},
	sections = {
	    lualine_a = {{"mode", upper = true}},
	    lualine_b = {{"branch", icon = ""}},
	    lualine_c = {{"filename", file_status = true}},
	    lualine_x = {"encoding", "fileformat", "filetype"},
	    lualine_y = {"progress"},
	    lualine_z = {"location"}
	},
	inactive_sections = {
	    lualine_a = {},
	    lualine_b = {},
	    lualine_c = {"filename"},
	    lualine_x = {"location"},
	    lualine_y = {},
	    lualine_z = {}
	},
	tabline = {},
	extensions = {}
    }
