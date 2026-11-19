---
projeto: NOME_DO_PROJETO
repo: org/repo            # usado pelo sync-github.sh (pode ter mais de um, ver repos abaixo)
repos:
  - org/repo-back
  - org/repo-front
atualizado: AAAA-MM-DD
---

# NOME_DO_PROJETO

## O que é
Uma ou duas frases: para quem é (ex.: time financeiro), qual problema resolve.

## Apps
| App       | Pasta     | Stack                        | Como rodar          |
|-----------|-----------|------------------------------|---------------------|
| back      | `back/`   | NestJS + PostgreSQL          | `npm run start:dev` |
| front     | `front/`  | Next.js + React               | `npm run dev`       |
| front-2   | `admin/`  | ...                          | ...                 |

## Arquitetura em 5 linhas
- Como front fala com back (REST/GraphQL, auth, BFF?)
- Integrações externas (ERP, filas, webhooks)
- Banco: schemas principais

## Padrões do projeto
- Estrutura de módulos, nomenclatura, como escrever testes
- Lib de UI / design system (ver `.knowledge/_shared/` se existir)

## Armadilhas conhecidas
- Coisas que já quebraram e por quê

## Domínios principais
- Faturamento → RN-001, RN-004, FT-002
- Usuários/permissões → RN-002
