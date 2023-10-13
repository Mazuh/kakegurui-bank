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

```sh
mix test
```

## Ambiente de entrega contínua

TODO.

## Casos de uso

### Cadastro de conta

Crie uma conta que servirá de acesso. O CPF será único e usado como identificador público (como
alguns bancos fazem) durante transações mais tarde, e o formato precisa ser mascarado, porém pode
ser inválido (como um fácil "111.111.111-11" durante experimentos).

```sh
curl -X POST http://localhost:4000/api/users \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
        "cpf": "052.490.668-87",
        "first_name": "João",
        "last_name": "da Silva",
        "pass": "my secret"
    }'
```

### Autenticação

Gere um token (com validade de 1 dia, de novo para facilitar experimentos):

```sh
curl -X POST http://localhost:4000/api/authentication \
    -H 'accept: application/json' \
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

E teste o token, isso deverá imprimir o primeiro nome do usuário autenticado:

```sh
curl http://localhost:4000/api/authentication \
    -H "Authorization: Bearer $KAKEGURUI_TOKEN"
```

### Cadastro de transação

```sh
# todo
```

### Estorno de transação

```sh
# todo
```

### Busca de transações por data

```sh
# todo
```

### Visualização de saldo

```sh
# todo
```

## Licença

Feito por [Marcell G. (Mazuh)](https://github.com/Mazuh/kakegurui-bank)
sob [MIT License](https://github.com/Mazuh/kakegurui-bank/blob/main/LICENSE).
