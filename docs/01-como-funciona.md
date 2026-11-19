# 01 — Como funciona

## A peça central: CLAUDE.md em cascata

O Claude Code procura arquivos `CLAUDE.md` no diretório onde foi aberto **e em todas as pastas acima dele**, e carrega todos no início da sessão.

```
~/Github/CLAUDE.md                    ← carregado (pasta avô)
~/Github/meu-projeto/CLAUDE.md        ← carregado se existir (do time, versionado)
~/Github/meu-projeto/back/            ← você abriu o Claude aqui
```

Por isso, basta um único `CLAUDE.md` na pasta do workspace para que **toda sessão, em qualquer repo**, já comece com as instruções da base. Você não precisa mexer em nenhum repositório.

## O que o CLAUDE.md diz ao Claude

Em resumo, são três combinados:

1. **Antes de trabalhar:** descubra o projeto pelo diretório, leia `CONTEXT.md` e `INDEX.md` e abra só o que for relevante.
2. **Se o código e a documentação discordarem:** pare e pergunte.
3. **Depois de trabalhar:** documente o que mudou (feature, regra ou decisão).

Ele também ensina as convenções (IDs, formato, onde fica cada coisa) e as regras de segurança.

## Por que em camadas: CONTEXT → INDEX → arquivo

A janela de contexto do Claude é finita. Se ele lesse tudo sempre, gastaria contexto à toa e as respostas piorariam.

| Camada | Tamanho | Quando é lida |
|---|---|---|
| `CONTEXT.md` | ~1 página | Sempre |
| `INDEX.md` | uma linha por item | Sempre |
| `regras/`, `features/`, `decisoes/` | um arquivo por item | Só os relevantes à tarefa |
| `github/` | uma issue/PR por arquivo | Só quando a tarefa cita um número |

É como um livro: sumário primeiro, depois só os capítulos que interessam.

## Por que Markdown com frontmatter

Cada arquivo começa com um bloco YAML:

```yaml
---
id: RN-004
dominio: faturamento
arquivos: [back/src/modules/billing/billing.service.ts]
relacionados: [FT-002]
---
```

Isso deixa os arquivos **pesquisáveis como código**: o Claude encontra tudo que toca em `billing.service.ts` com um `grep`, sem precisar de banco de dados, servidor ou MCP. É rápido, funciona offline e você consegue ler e editar à mão.

## Por que baixar issues e PRs para arquivos

Consultar a API do GitHub a cada tarefa é lento e gasta chamadas. O `sync-github.sh` baixa issues (com comentários) e PRs (com a lista de arquivos alterados) para Markdown. O Claude lê localmente, e o `SUMMARY.md` de cada projeto dá uma visão geral do que está acontecendo.

## O ciclo

```
   ┌────────────┐     ┌──────────┐     ┌────────────┐
   │  contexto  │ ──▶ │  tarefa  │ ──▶ │  registro  │
   └────────────┘     └──────────┘     └────────────┘
         ▲                                    │
         └──────────── base melhor ◀──────────┘
```

Cada tarefa lê a base e devolve um pouco de conhecimento para ela. Com o tempo, a base cobre os pontos do sistema em que você mais mexe, que são justamente os que mais importam.
