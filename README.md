# setup-linux

Automação de setup para Debian 13 Trixie e Ubuntu em máquinas headless de desenvolvimento.

## O que instala

- Pacotes base de terminal e build
- Python 3, pip, venv e pipx
- Zsh, Oh My Zsh e plugins
- Neovim, tmux e dotfiles versionados
- Node.js e npm na última versão estável via `n`
- pnpm, Codex CLI, Claude Code e GitHub Copilot CLI
- Docker Engine com Compose plugin
- GitHub CLI, DigitalOcean CLI e LazyGit

## Como usar

```bash
git clone <repo> setup-linux
cd setup-linux
./install.sh
```

O `install.sh` detecta Debian ou Ubuntu automaticamente.

## Variáveis úteis

- `SETUP_LINUX_DRY_RUN=1`: mostra as ações sem executar instalações.
- `SETUP_LINUX_MODULES=base,dotfiles`: roda apenas os módulos informados.
- `SETUP_LINUX_INTERACTIVE=1`: força o menu interativo de seleção de módulos.
- `SETUP_LINUX_ALLOW_NON_DEBIAN=1`: permite testes fora do Debian real.
- `SETUP_LINUX_FORCE_OS_ID`, `SETUP_LINUX_FORCE_OS_VERSION_ID`, `SETUP_LINUX_FORCE_OS_VERSION_CODENAME`, `SETUP_LINUX_FORCE_ARCH`: fixam o ambiente para testes.

## Pós-instalação

- Abra uma nova sessão para aplicar `chsh` e o grupo `docker`.
- Rode novamente `./install.sh` se quiser reaplicar dotfiles.
- Faça login manualmente apenas quando precisar usar cada ferramenta:
  - `gh auth login`
  - `copilot login`
  - `codex --login`
  - `claude`
  - `doctl auth init`
