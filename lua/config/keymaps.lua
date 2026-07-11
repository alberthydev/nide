vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Sair do modo de inserção" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Fechar janela" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque de busca" })

-- Navegação entre janelas (splits)
map("n", "<C-h>", "<C-w>h", { desc = "Ir para janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir para janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir para janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir para janela à direita" })

-- Abas nativas (tabpages) do Neovim
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Abrir nova aba" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Fechar aba atual" })
map("n", "]t", "<cmd>tabnext<CR>", { desc = "Próxima aba" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Aba anterior" })
