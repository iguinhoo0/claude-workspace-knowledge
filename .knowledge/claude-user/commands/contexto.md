---
description: Carrega o contexto de negócio do projeto atual antes de uma tarefa
argument-hint: [descrição da tarefa ou #issue]
---
Antes de escrever qualquer código, monte o contexto para esta tarefa: $ARGUMENTS

1. Descubra o projeto pelo diretório atual e leia `{{WORKSPACE}}/.knowledge/<projeto>/CONTEXT.md` e `INDEX.md`.
2. Se houver `#número`, leia a issue/PR em `{{WORKSPACE}}/.knowledge/<projeto>/github/`. Se não existir, rode `{{WORKSPACE}}/.knowledge/scripts/sync-github.sh <projeto>` e tente de novo.
3. Abra apenas as RN/FT/ADR relacionadas (pelo domínio, pelos arquivos citados ou por busca com grep na pasta).
4. Abra os arquivos de código citados nesses documentos e confirme que a implementação bate com a doc.

Responda com:
- **Resumo da tarefa** (2-3 linhas)
- **Regras de negócio que se aplicam** (IDs + uma linha cada)
- **Arquivos que provavelmente serão tocados** (back / front)
- **Divergências** entre doc e código, se houver
- **Dúvidas** que preciso responder antes de começar
- **Plano** em passos curtos

Não altere código ainda. Espere minha aprovação.
