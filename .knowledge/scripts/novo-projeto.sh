#!/usr/bin/env bash
# Cria a pasta de conhecimento de um projeto a partir do _template.
# Uso: ./novo-projeto.sh <nome-do-projeto> [<nome-do-projeto> ...]
# O nome deve ser igual ao da pasta do projeto no workspace.
set -euo pipefail
KDIR="$(cd "$(dirname "$0")/.." && pwd)"

[[ $# -gt 0 ]] || { echo "Uso: $0 <nome-do-projeto> [...]"; exit 1; }

for p in "$@"; do
  dest="$KDIR/$p"
  if [[ -d "$dest" ]]; then
    echo "• $p já existe, nada a fazer"
    continue
  fi
  cp -r "$KDIR/_template" "$dest"
  rm -f "$dest"/regras/*-template.md "$dest"/features/*-template.md "$dest"/decisoes/*-template.md
  mkdir -p "$dest"/{regras,features,decisoes,github/issues,github/prs}
  touch "$dest"/{regras,features,decisoes,github/issues,github/prs}/.keep
  sed -i.bak "s/NOME_DO_PROJETO/$p/g" "$dest/CONTEXT.md" "$dest/INDEX.md" && rm -f "$dest"/*.bak
  echo "✔ projeto criado: .knowledge/$p"
done
