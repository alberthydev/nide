vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_keepdir = 0

vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Abrir/fechar árvore de arquivos" })

require("fzf-lua").setup({
  winopts = {
    height = 0.6,
    width = 0.6,
    border = "rounded",
  },
})

local map = vim.keymap.set
local fzf = function()
  return require("fzf-lua")
end

map("n", "<leader>ff", function()
  fzf().files()
end, { desc = "Buscar arquivos por nome" })

map("n", "<leader>fg", function()
  fzf().live_grep()
end, { desc = "Buscar texto em todo o projeto" })

map("n", "<leader>fb", function()
  fzf().buffers()
end, { desc = "Buscar entre buffers abertos" })

map("n", "<leader>fh", function()
  fzf().help_tags()
end, { desc = "Buscar na documentação (:help)" })
