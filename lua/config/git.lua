local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

local map = vim.keymap.set

map("n", "]c", function()
  gitsigns.nav_hunk("next")
end, { desc = "Próxima alteração (git hunk)" })

map("n", "[c", function()
  gitsigns.nav_hunk("prev")
end, { desc = "Alteração anterior (git hunk)" })

map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Pré-visualizar alteração" })
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage da alteração (git add parcial)" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Descartar alteração" })
map("n", "<leader>hb", gitsigns.blame_line, { desc = "Ver blame da linha" })
