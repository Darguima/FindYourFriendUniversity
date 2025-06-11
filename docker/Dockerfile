FROM bitwalker/alpine-elixir-phoenix:1.15

ENV MIX_ENV=prod

RUN mkdir /app
WORKDIR /app

RUN apk update && apk add --no-cache python3

# Copy app files
COPY mix.exs mix.lock ./
COPY config/config.exs config/prod.exs config/runtime.exs config/
COPY priv priv
COPY lib lib
COPY assets assets

RUN mix deps.get

EXPOSE 4000

CMD ["sh", "-c", "mix ecto.create && mix ecto.migrate && mix assets.setup && mix assets.build && mix phx.digest && mix phx.server"]