---
description: Revisa o diff atual (ou um PR) contra as regras de negócio documentadas
argument-hint: [número do PR, opcional]
---
Revise as mudanças (PR #$ARGUMENTS via `gh pr diff`, ou `git diff` da branch atual contra a base se vazio) contra a base em `{{WORKSPACE}}/.knowledge/<projeto>/`.

Verifique:
- Alguma RN vigente é violada ou alterada sem a doc ser atualizada?
- A feature correspondente (FT) precisa de atualização?
- Contradiz alguma ADR?
- Bugs óbvios, casos de borda das regras (exceções listadas nas RN).

Saída: lista priorizada (bloqueante / importante / sugestão) com arquivo:linha e a RN/ADR envolvida.
