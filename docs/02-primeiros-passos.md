# 02 — Primeiros passos

## 1. Instale

```bash
git clone https://github.com/iguinhoo0/claude-workspace-knowledge.git
cd claude-workspace-knowledge
./install.sh ~/Github projeto-a projeto-b projeto-c
```

- O primeiro argumento é a pasta que agrupa seus repositórios. Ela **não pode** ser um repo git.
- Os demais são os nomes dos projetos, iguais aos nomes das pastas dos repos.
- Para adicionar um projeto depois: `~/Github/.knowledge/scripts/novo-projeto.sh projeto-d`.

## 2. Preencha o resumo de cada projeto

Abra o Claude Code dentro de `~/Github` e mande, um projeto por vez:

```
Leia projeto-a/ (todos os apps: back, front e o que mais houver). Preencha
.knowledge/projeto-a/CONTEXT.md seguindo o template: o que é, apps, stack, como
rodar, arquitetura em 5 linhas, padrões, armadilhas, domínios principais.
Use `git remote -v` de cada app para preencher `repos:` no formato org/repo.
Seja factual e cite caminhos. Mostre antes de gravar.
```

Revise com carinho: é o arquivo que o Claude lê **sempre**. Vale a pena corrigir o que ele errou e acrescentar o que só você sabe (as "armadilhas conhecidas" costumam ser a parte mais valiosa).

> Dica: faça um projeto por sessão, ou use `/clear` entre eles, para o contexto de um não contaminar o outro.

## 3. Sincronize o GitHub

```bash
gh auth login
~/Github/.knowledge/scripts/sync-github.sh             # todos os projetos
~/Github/.knowledge/scripts/sync-github.sh projeto-a   # só um
LIMIT=300 DAYS=90 ~/Github/.knowledge/scripts/sync-github.sh
```

Para manter atualizado sem lembrar, adicione ao cron (`crontab -e`):

```
40 8 * * 1-5 ~/Github/.knowledge/scripts/sync-github.sh >/dev/null 2>&1
```

## 4. (Opcional) Reconstrua as features a partir do histórico

```
Leia .knowledge/projeto-a/github/prs/ (PRs merged) e agrupe em features.
Para cada grupo, proponha um FT-XXX com issue, PRs, arquivos e regras relacionadas.
Me mostre a tabela antes de criar os arquivos.
```

## 5. (Opcional) Extraia as regras do código legado

Um módulo por vez, começando pelos que você mais mexe:

```
/extrair-regras projeto-a/back/src/modules/faturamento
```

Não tente documentar o projeto inteiro de uma vez. A qualidade cai muito em pedidos grandes. Um módulo por semana já faz uma diferença enorme em poucos meses.

## Pronto

A partir daqui, use `/issue <número>` no dia a dia. Veja [03 — Dia a dia](03-dia-a-dia.md).
