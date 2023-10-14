# Kakegurui Bank

> O teste que você irá realizar consiste em elaborar um servidor de registro de contas e
> transações financeiras. Esse sistema deve conseguir receber vários pedidos de transação
> simultaneamente, registrar de forma persistente o histórico de transações e retornar o
> saldo atual de cada conta. O sistema deve manter a todo momento a consistência dos dados
> fornecidos e ser capaz de escalar de forma simples.
>
> 🔗 https://github.com/appcumbuca/desafios/blob/c3a57889fe99d5a780afbd3421a7310c71334bf4/desafio-back-end.md

## Configuração de desenvolvimento local

Antes de tudo, alguns requisitos da máquina.

- Elixir 1.15 com Erlang/OTP 26.1 (caso tiver ASDF, `asdf install` e pronto).
- PostgreSQL 14 (na porta 5433).

Instalar dependências:

```sh
mix setup
```

E iniciar o servidor:

```sh
mix phx.server

# ou, em modo interativo:
# iex -S mix phx.server
```

Agora, rode o health check:

```sh
curl http://localhost:4000/api/health
```

E pronto, isso deve retornar um JSON de `{"status":"ok"}` como teste de sanidade.

## Testes automatizados

Não muitos, mas todos os casos de uso estão cobertos,
incluindo os exemplos aqui documentados e os
de notável importância tipo de privacidade.

```sh
mix test
```

## Ambiente de homologação

A fazer.

## Casos de uso

### Cadastro de conta

Crie uma conta que servirá de acesso. O CPF será único e usado como identificador público (como
alguns bancos fazem) durante transações mais tarde, e o formato precisa ser mascarado, porém pode
ser inválido (como um fácil "111.111.111-11" durante experimentos).

```sh
curl -X POST 'http://localhost:4000/api/users' \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "cpf": "052.490.668-87",
        "first_name": "João",
        "last_name": "da Silva",
        "pass": "my secret",
        "initial_balance": "1000.00"
    }'
```

Não há listagem nem consulta, pois não foram especificadas, e dado o contexto de fintech
pode implicar em um vazamento de dados. E nesse espírito o ID numérico auto-incrementado
também não é divulgado, para não revelar por exemplo quantos usuários há na organização.

O saldo inicial por `inicial_balance` é opcional e provavelmente só faz sentido neste
contexto lúdico de experimentação.

### Autenticação

Gere um token (com validade de 1 dia, de novo para facilitar experimentos):

```sh
curl -X POST 'http://localhost:4000/api/authentication' \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "cpf": "052.490.668-87",
        "pass": "my secret"
    }'
```

Para facilitar, guarde o valor de token retornado (uma string dividida em três pontos) em uma
variável para interpolação nas requests futuras:

```sh
KAKEGURUI_TOKEN='blablabla.blablabla.blablabla'
```

E faça o teste de sanidade no token se quiser, esta rota deverá imprimir o
primeiro nome do usuário autenticado:

```sh
curl 'http://localhost:4000/api/authentication' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN"
```

### Cadastro de transação

Efetua uma transação financeira de um montante que seu usuário possui
para algum outro usuário identificado através do CPF:

```sh
curl -X POST 'http://localhost:4000/api/fin_transactions' \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN" \
    -d '{
        "receiver_cpf": "111.111.111-11",
        "amount": "1.99"
    }'
```

Apenas para fins lúdicos, é permitido enviar dinheiro a si mesmo(a), como se
fosse um "depósito".

### Estorno de transação

Na busca por transação, armazene o UUID de alguma dentre as que você próprio originou:

```sh
KAKEGURUI_TRANSACTION='blabla-blabla-blabla-wadda-wadda'
```

E chame o endpoint de estorno:

```sh
curl -X POST "http://localhost:4000/api/fin_transactions/$KAKEGURUI_TRANSACTION/refund" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN"
```

Pelo endpoint de saldo dará para perceber a diferença.

Também não é possível estornar mais de uma vez a mesma transação financeira,
e não é possível reembolsar apenas uma fração mas sim todo o valor.

Transações feitas a si mesmo(a), os já explicados "depósitos para experimentos", não são
reembolsáveis.

Mensagens de erro aqui serão um pouco ambíguas para não revelar demais, como por exemplo
se a outra pessoa está sem dinheiro para fazer o reembolso.

### Busca de transações por data

Qualquer transação envolvendo seu usuário irá ser listada, inclusive as
já estornadas para consulta histórica:

```sh
curl 'http://localhost:4000/api/fin_transactions?from_processed_at=2023-01-01&to_processed_at=2023-12-31' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN"
```

O exemplo acima busca todas de 2023, os parâmetros `from_processed_at` e
`to_processed_at`, seguem a máscara `"AAAA-MM-DD"`, são um intervalo
inclusivo nas duas extremidades e são parâmetros obrigatórios.

### Visualização de saldo

Valor total de suas transações efetuadas e não estornadas,
o retorno é bem simples:

```sh
curl 'http://localhost:4000/api/balance' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN"
```

## Licença

Feito por [Marcell G. (Mazuh)](https://github.com/Mazuh/kakegurui-bank)
sob [MIT License](https://github.com/Mazuh/kakegurui-bank/blob/main/LICENSE).
