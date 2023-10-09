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

Agora abra [`localhost:4000`](http://localhost:4000) no browser e pronto.

## Casos de uso

TODO.
