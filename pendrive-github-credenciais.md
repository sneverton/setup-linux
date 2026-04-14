# Backup de credenciais do GitHub em pendrive

Este arquivo registra um procedimento simples para levar, em um pendrive, a chave SSH do GitHub e o token autenticado do GitHub CLI (`gh`).

## Aviso de segurança

- Evite guardar credenciais em texto puro.
- Se possível, use um pendrive criptografado ou um arquivo compactado com senha.
- Nunca compartilhe este pendrive sem proteger o conteúdo.

## Arquivos usados

- Chave SSH privada: `~/.ssh/id_ed25519`
- Chave SSH pública: `~/.ssh/id_ed25519.pub`
- Token do GitHub CLI: obtido com `gh auth token`

## Criar a cópia no pendrive

1. Monte o pendrive e descubra o ponto de montagem. Exemplo: `/media/$USER/PENDRIVE`
2. Crie uma pasta para guardar os arquivos:

```bash
mkdir -p /media/$USER/PENDRIVE/github-backup
```

3. Copie a chave SSH privada e a chave pública:

```bash
cp ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub /media/$USER/PENDRIVE/github-backup/
```

4. Salve o token do GitHub CLI em um arquivo:

```bash
gh auth token > /media/$USER/PENDRIVE/github-backup/gh-token.txt
```

5. Ajuste as permissões dos arquivos no pendrive:

```bash
chmod 600 /media/$USER/PENDRIVE/github-backup/id_ed25519
chmod 600 /media/$USER/PENDRIVE/github-backup/gh-token.txt
```

## Forma mais segura

Se quiser reduzir o risco, compacte a pasta inteira e proteja com senha antes de gravar no pendrive:

```bash
tar -czf github-backup.tar.gz -C /media/$USER/PENDRIVE github-backup
```

Depois mova o arquivo para o pendrive e use uma ferramenta de criptografia, como `gpg` ou um volume criptografado.

## Restaurar em outra máquina

1. Copie os arquivos do pendrive para a máquina nova.
2. Restaure a chave SSH em `~/.ssh/id_ed25519`.
3. Ajuste as permissões:

```bash
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

4. Reconfigure o `gh` com o token:

```bash
gh auth login --with-token < /caminho/para/gh-token.txt
```

Se preferir, faça o login manual com `gh auth login` e cole o token quando solicitado.

## Limpeza depois do uso

- Remova os arquivos do pendrive quando não forem mais necessários.
- Se o pendrive for compartilhado, apague o conteúdo e formate novamente.
- Considere revogar o token antigo se ele tiver sido exposto.
