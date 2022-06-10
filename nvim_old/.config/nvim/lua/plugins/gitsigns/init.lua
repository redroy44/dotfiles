require("gitsigns").setup {
  signs = {
    add = {text = "▎"},
    change = {text = "▎"},
    delete = {text = "▎"},
    topdelete = {text = "▎"},
    changedelete = {text = "▎"}
  },
  sign_priority = 100,
  linehl     = false,
  current_line_blame = true
}
