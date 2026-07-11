require("catppuccin").setup({
  flavour = "frappe",
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
    fzf = true,
    gitsigns = true,
  },
})

vim.cmd.colorscheme("catppuccin")
