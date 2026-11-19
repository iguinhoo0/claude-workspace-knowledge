#!/usr/bin/env bash
# Hook PostToolUse (Bash) do Claude Code.
# Quando o Claude roda `gh pr create` dentro do workspace, pede revisão + registro na base.
#
# O caminho do workspace vem de $CLAUDE_WORKSPACE_DIR ou, se não definido,
# da pasta duas acima deste script (…/<workspace>/.knowledge/scripts/hooks).
WORKSPACE="${CLAUDE_WORKSPACE_DIR:-$(cd "$(dirname "$0")/../../.." && pwd)}"

input="$(cat)"
cmd="$(jq -r '.tool_input.command // ""' <<<"$input")"
cwd="$(jq -r '.cwd // ""' <<<"$input")"

[[ "$cwd" == "$WORKSPACE"* ]] || exit 0

if grep -qE '(^|[;&|[:space:]])gh pr create' <<<"$cmd"; then
  jq -n '{
    decision: "block",
    reason: "PR aberto com sucesso. Sem pedir permissão para começar: (1) execute o roteiro de ~/.claude/commands/revisar-pr.md para o PR recém-criado (pegue o número com `gh pr view --json number`); se houver itens bloqueantes, proponha a correção. (2) Em seguida execute o roteiro de ~/.claude/commands/registrar.md, mostrando o conteúdo antes de gravar."
  }'
fi
exit 0
