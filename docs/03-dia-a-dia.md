# 03 — Dia a dia

## O fluxo padrão: `/issue`

Abra o Claude Code no repo em que vai trabalhar (ex.: `~/Github/projeto-a/back`) e digite:

```
/issue 482
```

### Fase 1 — Contexto (automático)
Ele baixa a issue se ainda não estiver local, lê o `CONTEXT.md`, o `INDEX.md`, as regras e features relacionadas e os arquivos de código citados nelas.

### Fase 2 — Plano (você aprova)
Ele responde com:

- **Resumo da tarefa**
- **Regras de negócio que se aplicam** (ex.: `RN-004 — desconto não acumula com cupom`)
- **Arquivos que provavelmente serão tocados**
- **Divergências** entre a documentação e o código
- **Dúvidas** que você precisa responder
- **Plano** em passos curtos

👉 **Leia as dúvidas e as divergências com atenção.** É ali que a base mais ajuda: é o momento em que o Claude mostra algo que, sem ela, ele teria assumido em silêncio.

### Fase 3 — Implementação (automático)
Cria a branch, implementa, roda lint e testes.

### Fase 4 — PR (você aprova)
Pergunta se pode abrir. Abre com descrição em português e `Refs #482`, que liga o PR à issue sem fechá-la. O fechamento da issue fica com você ou com o seu time.

### Fase 5 — Revisão + registro (automático, via hook)
Revisa o diff contra as regras e depois propõe as atualizações na base. Você aprova o que vai ser gravado.

## Tarefas sem issue

```
/contexto ajustar o cálculo de juros quando o boleto vence no fim de semana
```

Ou simplesmente descreva a tarefa: o `CLAUDE.md` faz o Claude montar o contexto antes de codar de qualquer jeito. Ao final, diga **"terminei"** e ele roda o registro.

## Durante a tarefa

Converse normalmente. Quando surgir uma regra que só existe na cabeça de alguém ("ah, mas cliente do plano antigo não pode..."), **conte para o Claude**. Ela vai entrar na base no registro.

## Comandos avulsos

| Situação | Comando |
|---|---|
| Revisar um PR de um colega | `/revisar-pr 517` |
| Documentar o que foi feito numa sessão sem PR | `/registrar` |
| Documentar um módulo antigo | `/extrair-regras projeto-a/back/src/modules/estoque` |
| Atualizar issues e PRs | `.knowledge/scripts/sync-github.sh` |

## Mantendo a base saudável

- **Aprove os registros com atenção.** Uma regra errada na base é pior que nenhuma.
- **Regra que mudou não se apaga:** ela recebe `status: obsoleta` e aponta para a nova. Assim o histórico de "por que mudou" fica guardado.
- **Mantenha o `INDEX.md` enxuto.** Se um projeto crescer muito, peça ao Claude para dividir o índice por domínio.
- **Revise o `CONTEXT.md` de vez em quando,** principalmente depois de mudanças de arquitetura.
