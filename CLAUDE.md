# Workspace — contexto local (NUNCA versionado)

Este arquivo fica na pasta que agrupa os seus repositórios (ex.: `~/Github/`), que NÃO é
um repositório git. O Claude Code carrega CLAUDE.md de todas as pastas acima do diretório
atual, então ele vale para qualquer repo aberto dentro dela.

## Projetos

Cada subpasta de `.knowledge/` é um projeto (exceto `_shared`, `_template`, `scripts`
e `claude-user`). O nome da subpasta é o mesmo da pasta do projeto no workspace:

    <workspace>/meu-projeto/        ← código (back/, front/, ...)
    <workspace>/.knowledge/meu-projeto/  ← conhecimento sobre ele

## Protocolo OBRIGATÓRIO antes de qualquer tarefa

1. Identifique o projeto pelo diretório atual (ou pelo que o usuário citar).
2. Leia `.knowledge/<projeto>/CONTEXT.md` (visão geral, stack, apps back/front).
3. Leia `.knowledge/<projeto>/INDEX.md` e abra SÓ os arquivos relevantes à tarefa
   (regras `RN-*`, features `FT-*`, decisões `ADR-*`).
4. Se a tarefa citar issue/PR (`#123`), leia o arquivo correspondente em
   `.knowledge/<projeto>/github/issues/` ou `github/prs/`. Se não existir, rode
   `.knowledge/scripts/sync-github.sh <projeto>`.
5. Se encontrar conflito entre código e regra documentada: PARE e pergunte.
   A regra documentada é a intenção do negócio; o código pode estar errado (ou a doc desatualizada).

## Automação

- Se o usuário citar uma issue (`#123` ou link) sem usar comando, siga o fluxo de
  `~/.claude/commands/issue.md`.
- Se o usuário pedir uma tarefa sem issue, aplique o roteiro de
  `~/.claude/commands/contexto.md` antes de escrever código.
- Se a tarefa terminar SEM abrir PR (o usuário disser "terminei", "pronto", "pode fechar"
  ou após um commit final), execute o roteiro de `~/.claude/commands/registrar.md`.
- Após `gh pr create`, um hook vai pedir revisão + registro: obedeça.

## Protocolo depois de concluir uma tarefa (roteiro do /registrar)

- Feature nova/alterada → criar/atualizar `features/FT-XXX-*.md` e o `INDEX.md`.
- Regra de negócio descoberta ou alterada → criar/atualizar `regras/RN-XXX-*.md`.
- Decisão técnica relevante (lib, padrão, trade-off) → `decisoes/ADR-XXX-*.md`.
- Mostre o conteúdo ao usuário antes de gravar.

## Convenções da base

- Tudo em Markdown com frontmatter YAML (id, titulo, projeto, apps, status, arquivos, relacionados).
- IDs sequenciais por projeto: `RN-001`, `FT-001`, `ADR-001`.
- Cite arquivos de código por caminho relativo ao projeto (`back/src/modules/...`).
- `github/` é GERADO pelo script — nunca editar à mão.
- Texto curto e factual. Regras escritas como "DADO / QUANDO / ENTÃO" sempre que possível.
- Termos de domínio comuns aos projetos: `.knowledge/_shared/glossario.md`.

## Segurança

- Nunca copiar segredos, tokens, .env ou dados de clientes para `.knowledge/`.
- Nada de `.knowledge/` ou deste CLAUDE.md vai para commits, PRs ou mensagens de commit.
