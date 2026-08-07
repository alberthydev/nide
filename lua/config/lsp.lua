-- Ajustes finos em servidores específicos ANTES de habilitá-los.
-- lua_ls precisa saber que "vim" é uma variável global válida,
-- senão ele acusa erro em toda a nossa própria config.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- Busca por nome + instala, usando o mesmo fzf-lua da Etapa 6, em vez de
-- precisar saber de cor o "código" do pacote (ex: ts_ls) antes de instalar.
local function mason_search_install()
  local registry = require("mason-registry")

  registry.refresh(function()
    local specs = registry.get_all_package_specs()
    local items = {}

    for _, spec in ipairs(specs) do
      local languages = spec.languages and table.concat(spec.languages, ", ") or ""
      local installed = registry.is_installed(spec.name)
      local icon = installed and "✓" or " "
      table.insert(items, string.format("%s %-35s %s", icon, spec.name, languages))
    end

    -- fzf-lua roda callbacks fora do "main loop" do Neovim às vezes;
    -- vim.schedule garante que abrir a UI aconteça de forma segura.
    vim.schedule(function()
      require("fzf-lua").fzf_exec(items, {
        prompt = "Mason (buscar por nome/linguagem)> ",
        actions = {
          ["default"] = function(selected)
            for _, line in ipairs(selected) do
              local name = line:match("^%S+%s+(%S+)")
              local pkg = registry.get_package(name)
              if pkg:is_installed() then
                vim.notify(name .. " já está instalado", vim.log.levels.INFO)
              else
                pkg:install()
                vim.notify("Instalando " .. name .. "...", vim.log.levels.INFO)
              end
            end
          end,
        },
      })
    end)
  end)
end

vim.keymap.set("n", "<leader>mi", mason_search_install, { desc = "Mason: buscar e instalar pacote por nome" })

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "html",
    "cssls",
  },
})

-- Aparência dos diagnósticos (erros/warnings) no buffer
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
})

-- Tudo aqui só roda quando um servidor LSP conecta a um buffer,
-- então esses mapeamentos só existem em arquivos com LSP ativo.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf

    -- Autocomplete nativo do Neovim (sem plugin de completion)
    if client and client:supports_method("textDocument/completion") then
      -- Por padrão, autotrigger só dispara nos "trigger characters" que
      -- CADA servidor declara (ex: "." ou "->") — não em toda letra normal.
      -- Isso faz o menu só aparecer em gatilhos bem específicos (o "<" do
      -- clangd depois de #include, por exemplo), não ao digitar um
      -- identificador comum tipo "printf". Estendendo pra todo caractere
      -- imprimível, o autocomplete passa a aparecer digitando normalmente.
      local trigger_chars = {}
      for i = 32, 126 do
        table.insert(trigger_chars, string.char(i))
      end
      client.server_capabilities.completionProvider = client.server_capabilities.completionProvider or {}
      client.server_capabilities.completionProvider.triggerCharacters = trigger_chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Ir para definição")
    map("n", "gr", vim.lsp.buf.references, "Ver referências")
    map("n", "K", vim.lsp.buf.hover, "Mostrar documentação")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cs", function()
      vim.lsp.buf.code_action({ context = { only = { "source" } } })
    end, "Code action de arquivo inteiro (organize imports, etc)")
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Formatar arquivo")
    map("n", "[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
    map("n", "]d", vim.diagnostic.goto_next, "Próximo diagnóstico")
  end,
})
