# 05 — Formato dos arquivos

Todos os modelos ficam em `.knowledge/_template/`.

## CONTEXT.md: o resumo do projeto

Lido em **toda** tarefa, então tem que ser curto (cerca de uma página):

- **O que é:** uma ou duas frases.
- **Apps:** tabela com pasta, stack e como rodar cada um (back, front, admin...).
- **Arquitetura em 5 linhas:** como as partes conversam, integrações, banco.
- **Padrões:** estrutura de módulos, nomenclatura, testes.
- **Armadilhas conhecidas:** o que já quebrou e por quê. ⭐ Costuma ser a seção mais valiosa.
- **Domínios principais:** cada domínio apontando para as regras e features.
- **`repos:`** no frontmatter: a lista `org/repo` usada pelo sync do GitHub.

## INDEX.md: o mapa

Uma linha por item, em três tabelas (regras, features, decisões). É mantido pelo Claude no `/registrar`.

## Regras de negócio: `regras/RN-XXX-slug.md`

```markdown
---
id: RN-004
titulo: Desconto não acumula com cupom
projeto: loja
dominio: checkout
apps: [back, front]
status: vigente        # vigente | proposta | obsoleta
origem: "issue #210"
arquivos:
  - back/src/modules/checkout/discount.service.ts
relacionados: [FT-007]
atualizado: 2026-11-19
---

## Regra
DADO um pedido com desconto promocional
QUANDO o cliente aplica um cupom
ENTÃO vale o maior dos dois, nunca a soma

## Exceções
- Clientes do plano corporativo acumulam até 30%
```

O formato **DADO / QUANDO / ENTÃO** é proposital: é inequívoco, fácil de revisar e vira caso de teste quase direto.

## Features: `features/FT-XXX-slug.md`

O que o usuário consegue fazer, como funciona (tela → endpoint → serviço → tabela), issue, PRs, regras envolvidas, decisões e débitos técnicos.

## Decisões: `decisoes/ADR-XXX-slug.md`

Formato clássico de ADR (*Architecture Decision Record*): contexto, decisão, alternativas descartadas e consequências. Use para escolhas que alguém vai questionar no futuro ("por que não usamos X?").

## github/ (gerado)

- `issues/<org>__<repo>__<n>.md`: issue com frontmatter e comentários.
- `prs/<org>__<repo>__<n>.md`: PR com descrição, branch, issues vinculadas e arquivos alterados.
- `SUMMARY.md`: tabela com tudo dos últimos N dias.

**Nunca edite à mão:** o próximo sync sobrescreve.

## _shared/

Conhecimento que vale para todos os projetos: glossário do negócio, design system, padrões da empresa, etc.

## Convenções gerais

- IDs sequenciais **por projeto** (`RN-001`, `RN-002`...).
- Caminhos de código sempre relativos à pasta do projeto.
- Texto curto e factual: é para o Claude (e para você) consultar, não para ler de ponta a ponta.
- **Nunca** segredos, tokens, conteúdo de `.env` ou dados de clientes.
