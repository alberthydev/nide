# NIDE (Neovim Integrated Development Environment)

Configuração de Neovim construída do zero, sem plugin manager externo, tudo gerenciado pelo `vim.pack`, o gerenciador de plugins nativo introduzido no Neovim 0.12.

LSP completa com Mason, Treesitter, debugger (DAP) e navegação de arquivos minimalista. Sinta-se à vontade pra usar como quiser, mas se o objetivo é aprender a montar a sua própria do zero, recomendo fortemente construir a sua também, é mais trabalhoso, mas você entende (e consegue consertar) cada peça.

## Requisitos

Precisa do **Neovim 0.12 ou mais recente** (é a versão mínima que tem `vim.pack`). Muitos gerenciadores de pacote das distros ainda distribuem versões antigas — confira com `nvim --version` antes de seguir. 

Além do Neovim em si:
- `git` - usado pelo `vim.pack` pra clonar plugins
- Compilador C (`gcc`/`clang`) - pro Treesitter compilar os parsers
- `tree-sitter` CLI (>= 0.25) - mais confiável instalar via Cargo (veja abaixo)
- `node` - pro debug adapter de JS/TS
- `fzf` - busca fuzzy de arquivos
- `unzip` e `curl` - usados pelo Mason pra baixar ferramentas

### Debian / Ubuntu

```sh
sudo apt update
sudo apt install -y git build-essential unzip curl nodejs npm fzf
```

### Fedora

```sh
sudo dnf install -y git gcc make unzip curl nodejs npm fzf
```

### Arch

```sh
sudo pacman -S --needed git base-devel unzip curl nodejs npm fzf
```

### WSL (Windows Subsystem for Linux)

Use uma distro Ubuntu/Debian dentro do WSL e siga os comandos da seção **Debian / Ubuntu** acima. Depois, instale um utilitário de clipboard pra integrar com o Windows:

```sh
sudo apt install -y wl-clipboard
```

### tree-sitter CLI (todas as distros)

O gerenciador de pacotes de cada distro costuma ter uma versão desatualizada. O caminho mais confiável é via Cargo:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install tree-sitter-cli
```

Depois, garanta que `~/.cargo/bin` está no seu `PATH`.

## Instalação

```sh
git clone https://github.com/alberthydev/nide.git ~/.config/nvim
nvim
```

Na primeira abertura, `vim.pack.add` clona todos os plugins automaticamente — pode levar alguns segundos. Depois disso, um arquivo `nvim-pack-lock.json` vai aparecer na raiz da config; faça commit dele junto com o resto, é o que garante que outra máquina instale exatamente as mesmas versões.

## Estrutura

```
nvim-dotfiles/
├── init.lua                  -- só orquestra os módulos abaixo, nessa ordem
└── lua/config/
    ├── options.lua            -- opções nativas do editor
    ├── keymaps.lua            -- atalhos gerais + navegação de janelas/abas
    ├── plugins.lua            -- toda a lista de vim.pack.add
    ├── colorscheme.lua        -- tema catppuccin
    ├── treesitter.lua         -- parsers + highlight/indent/fold
    ├── lsp.lua                -- Mason + LSP nativo + code actions
    ├── dap.lua                -- debugger (nvim-dap) + adapter JS/TS
    ├── explorer.lua           -- netrw (árvore) + fzf-lua (busca fuzzy)
    ├── git.lua                -- gitsigns (hunks, blame)
    └── statusline.lua         -- lualine
```
