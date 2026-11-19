#!/usr/bin/env bash
# Sincroniza issues e PRs do GitHub para Markdown local (.knowledge/<projeto>/github/).
# Requisitos: gh (autenticado: `gh auth login`) e jq.
#
# Uso:
#   ./sync-github.sh                 # todos os projetos
#   ./sync-github.sh meu-projeto     # só um projeto
#   LIMIT=300 DAYS=90 ./sync-github.sh meu-projeto
#
# Os repos de cada projeto vêm do frontmatter `repos:` em .knowledge/<projeto>/CONTEXT.md
set -euo pipefail

KDIR="$(cd "$(dirname "$0")/.." && pwd)"
LIMIT="${LIMIT:-200}"
DAYS="${DAYS:-180}"
SINCE="$(date -d "-${DAYS} days" +%F 2>/dev/null || date -v-"${DAYS}"d +%F)"

command -v gh >/dev/null || { echo "Instale o gh CLI"; exit 1; }
command -v jq >/dev/null || { echo "Instale o jq"; exit 1; }

repos_of() {
  # lê a lista `repos:` do frontmatter do CONTEXT.md
  awk '/^---/{f++; next} f==1 && /^repos:/{r=1; next} f==1 && r && /^  - /{sub(/^  - /,""); sub(/ *#.*/,""); print; next} f==1 && r && !/^  - /{r=0}' "$1"
}

sync_project() {
  local proj="$1" ctx="$KDIR/$1/CONTEXT.md"
  [[ -f "$ctx" ]] || { echo "skip $proj (sem CONTEXT.md)"; return; }
  local out="$KDIR/$proj/github"
  mkdir -p "$out/issues" "$out/prs"
  local summary="$out/SUMMARY.md"
  {
    echo "# GitHub — $proj (gerado em $(date '+%F %H:%M'), últimos ${DAYS} dias)"
    echo "> Arquivo gerado. Não editar."
  } > "$summary"

  while read -r repo; do
    [[ -z "$repo" || "$repo" == org/* ]] && continue
    echo "→ $proj :: $repo"
    local slug="${repo//\//__}"

    # ---------- ISSUES ----------
    echo -e "\n## Issues ($repo)\n| # | Título | Estado | Labels | Atualizado |\n|---|---|---|---|---|" >> "$summary"
    gh issue list -R "$repo" --state all --limit "$LIMIT" \
      --search "updated:>=$SINCE" \
      --json number,title,state,labels,assignees,author,createdAt,updatedAt,closedAt,body,url \
    | jq -c '.[]' | while read -r it; do
        n=$(jq -r .number <<<"$it")
        f="$out/issues/${slug}__${n}.md"
        jq -r --arg repo "$repo" '
"---
tipo: issue
repo: \($repo)
numero: \(.number)
titulo: \(.title|@json)
estado: \(.state)
labels: \([.labels[].name]|@json)
responsaveis: \([.assignees[].login]|@json)
autor: \(.author.login)
criado: \(.createdAt)
atualizado: \(.updatedAt)
fechado: \(.closedAt // "")
url: \(.url)
---

# #\(.number) \(.title)

\(.body // "_sem descrição_")"' <<<"$it" > "$f"
        # comentários (só das issues abertas ou atualizadas recentemente — economiza API)
        gh issue view "$n" -R "$repo" --json comments \
          | jq -r '.comments[]? | "\n---\n**\(.author.login)** em \(.createdAt):\n\n\(.body)"' >> "$f" || true
        jq -r '"| \(.number) | \(.title|gsub("\\|";"/")) | \(.state) | \([.labels[].name]|join(", ")) | \(.updatedAt[0:10]) |"' <<<"$it" >> "$summary"
      done

    # ---------- PRs ----------
    echo -e "\n## PRs ($repo)\n| # | Título | Estado | Branch | Atualizado |\n|---|---|---|---|---|" >> "$summary"
    gh pr list -R "$repo" --state all --limit "$LIMIT" \
      --search "updated:>=$SINCE" \
      --json number,title,state,author,headRefName,baseRefName,createdAt,updatedAt,mergedAt,body,url,files,closingIssuesReferences \
    | jq -c '.[]' | while read -r pr; do
        n=$(jq -r .number <<<"$pr")
        f="$out/prs/${slug}__${n}.md"
        jq -r --arg repo "$repo" '
"---
tipo: pr
repo: \($repo)
numero: \(.number)
titulo: \(.title|@json)
estado: \(.state)
autor: \(.author.login)
branch: \(.headRefName) -> \(.baseRefName)
criado: \(.createdAt)
atualizado: \(.updatedAt)
merged: \(.mergedAt // "")
issues_vinculadas: \([.closingIssuesReferences[]?.number]|@json)
url: \(.url)
---

# PR #\(.number) \(.title)

\(.body // "_sem descrição_")

## Arquivos alterados
\([.files[]? | "- `\(.path)` (+\(.additions)/-\(.deletions))"] | join("\n"))"' <<<"$pr" > "$f"
        jq -r '"| \(.number) | \(.title|gsub("\\|";"/")) | \(.state) | \(.headRefName) | \(.updatedAt[0:10]) |"' <<<"$pr" >> "$summary"
      done
  done < <(repos_of "$ctx")
  echo "✔ $proj → $out"
}

if [[ $# -gt 0 ]]; then
  sync_project "$1"
else
  for d in "$KDIR"/*/; do
    p="$(basename "$d")"
    [[ "$p" == _* || "$p" == scripts || "$p" == claude-user ]] && continue
    sync_project "$p"
  done
fi
