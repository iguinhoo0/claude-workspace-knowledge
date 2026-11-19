# 🧠 claude-workspace-knowledge

**Uma "memória de projeto" local para o Claude Code entender as regras de negócio dos seus sistemas antes de tocar no código.**

Você trabalha em vários projetos, cada um com back-end, front-end e às vezes mais de um front. O Claude é ótimo lendo código, mas código mostra *o que foi feito*, não *o que deveria ser feito*. Ele não sabe que "uma nota só pode ser cancelada em até 24h" ou que "clientes do plano X não veem aquele relatório", a menos que alguém conte toda vez.

Este repositório resolve isso com uma ideia simples: **uma pasta de conhecimento em Markdown, ao lado dos seus repositórios, que o Claude lê sozinho antes de cada tarefa e atualiza sozinho depois.**

E o melhor: **tudo fica só na sua máquina.** Nada disso vai parar nos repositórios da empresa.

---

## Sumário

- [O problema](#o-problema)
- [A ideia em 30 segundos](#a-ideia-em-30-segundos)
- [Como fica a sua pasta](#como-fica-a-sua-pasta)
- [Instalação](#instalação)
- [O dia a dia](#o-dia-a-dia)
- [Os comandos](#os-comandos)
- [O que acontece automaticamente](#o-que-acontece-automaticamente)
- [Por que isso ajuda](#por-que-isso-ajuda)
- [Por que nada vaza para o git](#por-que-nada-vaza-para-o-git)
- [Perguntas frequentes](#perguntas-frequentes)
- [Documentação completa](#documentação-completa)

---

## O problema

Sem contexto, toda sessão com o Claude começa assim:

> "Então, esse projeto é um portal pra X, o back é NestJS, o front é Next, a regra de faturamento funciona assim, mas tem uma exceção pra clientes antigos, e cuidado com aquele módulo porque..."

E, mesmo assim, ele vai esquecer na próxima sessão. Pior: quando ele não sabe a regra, ele **adivinha**, e a adivinhação parece certa até chegar em produção.

## A ideia em 30 segundos

1. Você tem uma pasta que agrupa seus repositórios (ex.: `~/Github/`). Ela **não** é um repositório git.
2. Nela você coloca um `CLAUDE.md` e uma pasta `.knowledge/`.
3. O Claude Code lê automaticamente qualquer `CLAUDE.md` das pastas *acima* de onde ele está rodando. Então, ao abrir o Claude em `~/Github/meu-projeto/back`, ele já recebe as instruções.
4. Essas instruções dizem: *"antes de qualquer tarefa, leia o resumo do projeto, o índice de regras e só os arquivos relevantes. Depois que terminar, documente o que mudou."*
5. Issues e PRs do GitHub são baixados para Markdown por um script, então o Claude lê tudo localmente, rápido, sem depender de API.

É isso. Arquivos de texto, um script e alguns comandos.

## Como fica a sua pasta

```
~/Github/
├── CLAUDE.md                  ← as "regras do jogo" para o Claude (lido automaticamente)
├── .knowledge/                ← a base de conhecimento
│   ├── _shared/glossario.md   ← termos do negócio comuns a todos os projetos
│   ├── _template/             ← modelo usado para criar novos projetos
│   ├── meu-projeto/
│   │   ├── CONTEXT.md         ← o que é o projeto, stack, apps, como rodar
│   │   ├── INDEX.md           ← mapa de tudo que está documentado (uma linha por item)
│   │   ├── regras/RN-001-*.md ← regras de negócio
│   │   ├── features/FT-001-*.md ← features entregues
│   │   ├── decisoes/ADR-001-*.md ← decisões técnicas
│   │   └── github/            ← issues e PRs baixados (gerado pelo script)
│   └── scripts/               ← sync do GitHub, criação de projeto, hook
│
├── meu-projeto/               ← seus repositórios, intocados
│   ├── back/
│   └── front/
└── outro-projeto/
```

Os seus repositórios continuam exatamente como estão. A base fica *ao lado* deles.

## Instalação

**Pré-requisitos:** [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), [`jq`](https://jqlang.github.io/jq/) e [`gh`](https://cli.github.com/) (GitHub CLI).

```bash
git clone https://github.com/iguinhoo0/claude-workspace-knowledge.git
cd claude-workspace-knowledge

# ./install.sh <pasta-do-workspace> <projeto> <projeto> ...
./install.sh ~/Github api-pagamentos portal-web
```

Os nomes dos projetos devem ser iguais aos nomes das pastas dos repositórios dentro do workspace.

O instalador:
- copia o `CLAUDE.md` e a `.knowledge/` para o workspace, **sem sobrescrever nada**;
- cria a pasta de conhecimento de cada projeto;
- instala os comandos (`/issue`, `/contexto`, `/registrar`...) em `~/.claude/commands`;
- registra um hook no Claude Code que roda depois que um PR é aberto;
- protege os repositórios para nenhum arquivo local ir parar num commit.

Depois disso, peça ao próprio Claude para preencher o resumo de cada projeto (o prompt está em [docs/02-primeiros-passos.md](docs/02-primeiros-passos.md)) e sincronize o GitHub:

```bash
gh auth login
~/Github/.knowledge/scripts/sync-github.sh
```

## O dia a dia

Na prática, o fluxo inteiro é:

```
/issue 482
```

E daí em diante:

1. 🔍 **Contexto:** o Claude baixa a issue, lê o resumo do projeto, encontra as regras de negócio que se aplicam e confere se o código bate com elas.
2. 📝 **Plano:** ele mostra um resumo, as regras envolvidas, os arquivos que vai mexer, as **dúvidas** e as **divergências** que encontrou. Depois **para e espera você aprovar**.
3. 🛠️ **Implementação:** cria a branch, implementa, roda lint e testes.
4. 🚀 **PR:** pergunta se pode abrir o PR e abre com `Refs #482` (liga o PR à issue, sem fechá-la).
5. 🔎 **Revisão automática:** assim que o PR é aberto, ele revisa o diff contra as regras documentadas.
6. 📚 **Registro automático:** em seguida, atualiza a base (features, regras, decisões) e mostra o que vai gravar.

Você digita um comando e faz três aprovações. O resto acontece sozinho, e a base fica um pouco mais completa a cada tarefa.

## Os comandos

| Comando | Quando usar |
|---|---|
| `/issue 482` | Tarefa que veio de uma issue. Faz o fluxo completo. |
| `/contexto <descrição>` | Tarefa sem issue (veio do Slack, de uma reunião...). Só monta o contexto e o plano. |
| `/revisar-pr [número]` | Revisa um PR (ou a branch atual) contra as regras de negócio. |
| `/registrar` | Documenta o que foi feito na sessão. |
| `/extrair-regras <pasta>` | Lê um módulo antigo e propõe as regras de negócio que estão "escondidas" no código. |

Você nem precisa decorar: se escrever *"vamos resolver a #482"*, o Claude já segue o fluxo do `/issue`. Se disser *"terminei"*, ele roda o registro.

## O que acontece automaticamente

| Momento | O que dispara | O que acontece |
|---|---|---|
| Abriu o Claude em qualquer repo do workspace | `CLAUDE.md` da pasta pai | Ele já sabe onde está a base e como usá-la |
| Citou uma issue | Regra no `CLAUDE.md` | Segue o fluxo do `/issue` |
| O Claude rodou `gh pr create` | Hook `PostToolUse` | Revisão do PR + registro na base |
| Você disse "terminei" sem abrir PR | Regra no `CLAUDE.md` | Registro na base |

## Por que isso ajuda

- **O Claude para de adivinhar regra de negócio.** Ele passa a saber a *intenção* por trás do código, incluindo as exceções.
- **Você para de repetir contexto.** Toda sessão, em todo repo, já começa sabendo o que é o projeto.
- **Respostas melhores gastando menos contexto.** O `INDEX.md` faz o Claude abrir os 3 arquivos certos em vez de varrer 40.
- **Divergências viram achados.** Quando o código e a regra documentada discordam, ou é um bug, ou é uma regra que mudou sem ninguém registrar. As duas coisas valem ouro.
- **Revisão de PR com olhar de negócio.** Não só lint e estilo: a revisão confere se alguma regra foi quebrada.
- **Memória técnica de verdade.** Daqui a 6 meses, "por que isso funciona assim?" tem resposta, com a issue e o PR linkados. Também é ótimo para onboarding.

## Por que nada vaza para o git

- A pasta do workspace (`~/Github/`) **não é um repositório**, então o `CLAUDE.md` e a `.knowledge/` não pertencem a nenhum repo.
- O instalador adiciona `CLAUDE.local.md`, `.knowledge/` e `.claude/settings.local.json` ao `.git/info/exclude` de cada repo. É um "gitignore pessoal" que **também não é versionado**, então ninguém do time vê.
- O `CLAUDE.md` instrui o Claude a nunca mencionar a base em commits ou PRs, e a nunca copiar segredos ou dados de clientes para ela.

## Perguntas frequentes

**Funciona no Claude Desktop?**
Funciona na aba **Code** do Claude Desktop e no Claude Code CLI. No chat comum do Desktop, os comandos e o hook não rodam.

**E se eu abrir o PR pelo site do GitHub?**
O hook só percebe PRs abertos pelo Claude. Nesse caso, rode `/revisar-pr` manualmente.

**Preciso documentar tudo antes de começar?**
Não. Preencha só o `CONTEXT.md` de cada projeto. As regras e features vão surgindo conforme você trabalha. Se quiser acelerar, use `/extrair-regras` um módulo por vez.

**Minha empresa já usa CLAUDE.md nos repositórios. Conflita?**
Não. O Claude Code carrega os dois: o do repo (do time) e o do workspace (seu). Eles se somam.

**O time pode usar também?**
Pode. Cada pessoa instala a sua própria base local. Se quiserem uma base compartilhada, dá para versionar a `.knowledge/` num repositório privado separado.

**Dá para usar com outro provedor que não seja o GitHub?**
A base funciona com qualquer um. Só o `sync-github.sh` e o hook dependem do `gh`, e dá para adaptar para `glab` (GitLab) com poucas mudanças.

## Documentação completa

| Documento | Conteúdo |
|---|---|
| [01 — Como funciona](docs/01-como-funciona.md) | Os conceitos, como o Claude carrega o contexto, por que Markdown |
| [02 — Primeiros passos](docs/02-primeiros-passos.md) | Instalação detalhada e prompts para popular a base |
| [03 — Dia a dia](docs/03-dia-a-dia.md) | O fluxo completo com exemplos |
| [04 — Automação](docs/04-automacao.md) | O hook pós-PR, como funciona e como desativar |
| [05 — Formato dos arquivos](docs/05-formato-dos-arquivos.md) | Regras (RN), features (FT), decisões (ADR) e convenções |

---

Licença [MIT](LICENSE). Sugestões e PRs são bem-vindos.
