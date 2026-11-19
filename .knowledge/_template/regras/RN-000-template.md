---
id: RN-000
titulo: Título curto da regra
projeto: NOME_DO_PROJETO
dominio: faturamento
apps: [back, front]
status: vigente            # vigente | proposta | obsoleta
origem: "issue #123 / conversa com PO / código"
arquivos:
  - back/src/modules/xxx/xxx.service.ts
  - front/src/features/xxx/useXxx.ts
relacionados: [FT-001, ADR-001]
atualizado: AAAA-MM-DD
---

## Regra
DADO <contexto>
QUANDO <ação>
ENTÃO <resultado esperado>

## Exceções
- ...

## Exemplos
| Entrada | Resultado |
|---------|-----------|
| ...     | ...       |

## Onde está implementada
- Validação no back: `arquivo:função`
- Reflexo no front: `arquivo:componente`
