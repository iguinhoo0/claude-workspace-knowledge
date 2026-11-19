---
description: Varre um módulo do código e extrai regras de negócio para a base local
argument-hint: <caminho do módulo, ex.: back/src/modules/faturamento>
---
Analise o código em `$ARGUMENTS` (e o front correspondente, se existir) e extraia as regras de negócio implícitas: validações, cálculos, permissões, estados/transições, limites, mensagens de erro para o usuário.

Para cada regra:
- Verifique se já existe em `{{WORKSPACE}}/.knowledge/<projeto>/regras/` (grep pelo domínio e pelos arquivos).
- Se não existir, proponha `RN-XXX` no template do projeto, com `arquivos:` apontando a linha/função.
- Se existir e divergir do código, liste como **divergência** (não sobrescreva).

Primeiro me mostre uma tabela: ID proposto | regra em uma linha | arquivo:função | nova/existente/divergente.
Só grave depois que eu aprovar.
