---
description: Documenta na base local o que foi feito nesta sessão (features, regras, decisões)
argument-hint: [observações opcionais]
---
Revise o que fizemos nesta sessão (conversa + `git diff` / `git log` da branch atual contra a base) e atualize a base em `{{WORKSPACE}}/.knowledge/<projeto>/`. Observações: $ARGUMENTS

- Feature nova/alterada → `features/FT-XXX-slug.md` (use o template `_template/features/FT-000-template.md`, próximo ID livre).
- Regra de negócio nova, alterada ou que ficou implícita no código → `regras/RN-XXX-slug.md` no formato DADO/QUANDO/ENTÃO.
- Decisão técnica relevante → `decisoes/ADR-XXX-slug.md`.
- Atualize o `INDEX.md` e, se mudou arquitetura/padrões, o `CONTEXT.md`.
- Regra que deixou de valer: marque `status: obsoleta` e aponte a substituta — não apague.

Regras: texto curto, factual, com caminhos de arquivo. Sem segredos nem dados de cliente.
Mostre a lista de arquivos criados/alterados e o conteúdo antes de gravar.
