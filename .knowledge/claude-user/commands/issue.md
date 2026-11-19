---
description: Fluxo completo a partir de uma issue — contexto, plano, implementação e PR
argument-hint: <número da issue>
---
Trabalhe na issue #$ARGUMENTS seguindo as fases abaixo.

## Fase 1 — Contexto
- Se a issue não estiver em `{{WORKSPACE}}/.knowledge/<projeto>/github/issues/`, rode
  `{{WORKSPACE}}/.knowledge/scripts/sync-github.sh <projeto>`.
- Leia a issue (com comentários), os PRs relacionados, `CONTEXT.md`, `INDEX.md` e as RN/FT/ADR relevantes.
- Siga o mesmo roteiro e formato de resposta de `~/.claude/commands/contexto.md`.

## Fase 2 — Plano
- Apresente o plano e PARE, esperando minha aprovação.

## Fase 3 — Implementação
- Crie uma branch a partir da branch base do repo (padrão: `tipo/<numero>-slug`).
- Implemente, depois rode lint e testes do app afetado.

## Fase 4 — PR
- Pergunte se pode abrir o PR. Ao confirmar, abra com `gh pr create`: título claro, descrição em
  português (o quê, por quê, como testar, regras RN-* envolvidas) e `Closes #<numero>`.
- Nunca mencione `.knowledge` nem `CLAUDE.md` no PR ou nos commits.
- A revisão e o registro pós-PR são disparados automaticamente por hook.
