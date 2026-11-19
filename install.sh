#!/usr/bin/env bash
# Instala a base de contexto local no seu workspace.
#
# Uso:
#   ./install.sh [pasta-do-workspace] [projeto ...]
#
# Exemplos:
#   ./install.sh                                  # usa ~/Github, sem criar projetos
#   ./install.sh ~/Github api-pagamentos portal-web
#
# O que faz:
#   1. Copia CLAUDE.md e .knowledge/ para o workspace (sem sobrescrever nada que já exista)
#   2. Cria a pasta de conhecimento de cada projeto informado
#   3. Instala os slash commands em ~/.claude/commands
#   4. Registra o hook pós-PR em ~/.claude/settings.json (merge, sem apagar o que existe)
#   5. Adiciona arquivos locais ao .git/info/exclude de cada repo do workspace
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${1:-$HOME/Github}"
shift || true
WORKSPACE="$(mkdir -p "$WORKSPACE" && cd "$WORKSPACE" && pwd)"

command -v jq >/dev/null || { echo "✖ Instale o jq antes (brew install jq / apt install jq)"; exit 1; }
command -v gh >/dev/null || echo "⚠ gh CLI não encontrado — o sync de issues/PRs não vai funcionar até instalar"

# 0) O workspace não pode ser um repositório git
if top="$(git -C "$WORKSPACE" rev-parse --show-toplevel 2>/dev/null)" && [[ "$top" == "$WORKSPACE" ]]; then
  echo "✖ $WORKSPACE é um repositório git. Use uma pasta que apenas agrupe seus repos."; exit 1
fi

# 1) Arquivos do workspace
if [[ -f "$WORKSPACE/CLAUDE.md" ]]; then
  cp "$SRC/CLAUDE.md" "$WORKSPACE/CLAUDE.md.novo"
  echo "⚠ Já existe um CLAUDE.md — a versão nova foi salva como CLAUDE.md.novo para você comparar"
else
  cp "$SRC/CLAUDE.md" "$WORKSPACE/CLAUDE.md"
  echo "✔ CLAUDE.md copiado"
fi
mkdir -p "$WORKSPACE/.knowledge"
cp -Rn "$SRC/.knowledge/." "$WORKSPACE/.knowledge/" 2>/dev/null || true
chmod +x "$WORKSPACE"/.knowledge/scripts/*.sh "$WORKSPACE"/.knowledge/scripts/hooks/*.sh
echo "✔ .knowledge/ copiado"

# 2) Projetos
if [[ $# -gt 0 ]]; then
  "$WORKSPACE/.knowledge/scripts/novo-projeto.sh" "$@"
fi

# 3) Slash commands (com o caminho real do workspace)
mkdir -p "$HOME/.claude/commands"
for f in "$WORKSPACE"/.knowledge/claude-user/commands/*.md; do
  sed "s#{{WORKSPACE}}#$WORKSPACE#g" "$f" > "$HOME/.claude/commands/$(basename "$f")"
done
echo "✔ slash commands instalados em ~/.claude/commands"

# 4) Hook pós-PR
SETTINGS="$HOME/.claude/settings.json"
HOOK_CMD="$WORKSPACE/.knowledge/scripts/hooks/post-pr.sh"
[[ -f "$SETTINGS" ]] || echo '{}' > "$SETTINGS"
if jq -e --arg c "$HOOK_CMD" '[.hooks.PostToolUse[]?.hooks[]?.command] | index($c)' "$SETTINGS" >/dev/null; then
  echo "• hook pós-PR já registrado"
else
  cp "$SETTINGS" "$SETTINGS.bak"
  jq --arg c "$HOOK_CMD" '
    .hooks.PostToolUse = ((.hooks.PostToolUse // []) + [
      { matcher: "Bash", hooks: [ { type: "command", command: $c } ] }
    ])' "$SETTINGS.bak" > "$SETTINGS"
  echo "✔ hook pós-PR registrado (backup em settings.json.bak)"
fi

# 5) Ignore local em cada repo (não versionado)
find "$WORKSPACE" -mindepth 2 -maxdepth 3 -name .git -type d 2>/dev/null | while read -r g; do
  ex="$g/info/exclude"; mkdir -p "$(dirname "$ex")"; touch "$ex"
  for pat in "CLAUDE.local.md" ".claude/settings.local.json" ".knowledge/"; do
    grep -qxF "$pat" "$ex" || echo "$pat" >> "$ex"
  done
done
echo "✔ .git/info/exclude atualizado nos repos encontrados"

cat <<EOF

Pronto! Próximos passos:
  1. Para cada projeto, preencha .knowledge/<projeto>/CONTEXT.md (ou peça ao Claude — veja docs/02-primeiros-passos.md)
  2. gh auth login
  3. $WORKSPACE/.knowledge/scripts/sync-github.sh
  4. Abra o Claude Code dentro de $WORKSPACE e use /issue <número>
EOF
