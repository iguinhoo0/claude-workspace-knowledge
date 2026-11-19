# 04 — Automação

Há dois mecanismos de automação: **instruções no `CLAUDE.md`** e **um hook do Claude Code**.

## Instruções no CLAUDE.md

São "combinados" que o Claude segue por estar lendo o arquivo:

| Gatilho | Comportamento |
|---|---|
| Você cita uma issue (`#123`) sem comando | Segue o fluxo do `/issue` |
| Você pede uma tarefa sem issue | Monta o contexto antes de codar |
| Você diz "terminei", "pronto", "pode fechar" | Roda o registro |

Elas são flexíveis (você pode pedir para ele pular), mas dependem do Claude seguir as instruções. Na prática, ele segue bem.

## O hook pós-PR

Hooks são scripts que o Claude Code executa em momentos específicos, **independentemente** do que o modelo decidir. Este projeto usa um hook `PostToolUse`, que roda depois de cada comando de terminal executado pelo Claude.

O script `.knowledge/scripts/hooks/post-pr.sh`:

1. Recebe do Claude Code (via stdin) um JSON com o comando executado e o diretório.
2. Ignora tudo que não está dentro do seu workspace.
3. Se o comando foi `gh pr create`, responde com `decision: "block"` e uma mensagem. Para hooks `PostToolUse`, isso **não desfaz nada**: só devolve a mensagem ao Claude como uma instrução imediata.
4. A mensagem pede: rodar o roteiro de `/revisar-pr` no PR recém-criado e, em seguida, o de `/registrar`.

Ele fica registrado em `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "/home/voce/Github/.knowledge/scripts/hooks/post-pr.sh" }
        ]
      }
    ]
  }
}
```

### Testando o hook

```bash
H=~/Github/.knowledge/scripts/hooks/post-pr.sh

# deve imprimir um JSON com "decision": "block"
echo '{"tool_input":{"command":"gh pr create --fill"},"cwd":"'$HOME'/Github/projeto-a/back"}' | $H

# não deve imprimir nada
echo '{"tool_input":{"command":"git status"},"cwd":"'$HOME'/Github/projeto-a/back"}' | $H
echo '{"tool_input":{"command":"gh pr create"},"cwd":"/tmp"}' | $H
```

### Desativando

Remova o bloco correspondente de `~/.claude/settings.json`. O instalador deixa um backup em `settings.json.bak`.

## Por que o gatilho é o PR (e não "o fim da sessão")

O Claude Code também tem um hook `Stop`, mas ele dispara **toda vez que o Claude termina uma resposta**, não quando a tarefa acaba. Usá-lo para o registro faria o Claude documentar no meio do trabalho, várias vezes. A abertura do PR é o marco natural de "tarefa concluída".

## Limitações

- O hook só percebe PRs abertos **pelo Claude** (`gh pr create`). PR aberto pelo site do GitHub → rode `/revisar-pr` à mão.
- Hooks funcionam no Claude Code CLI e na aba **Code** do Claude Desktop, não no chat comum.
- Requer `jq` instalado.
