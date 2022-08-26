ARG ELIXIR_VERSION=1.10.4
ARG ERLANG_VERSION=23.0.4
ARG ALPINE_VERSION=3.12.0

ARG KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
ARG KERL_BUILD_DOCS="yes"
ARG ERL_AFLAGS="+pc unicode -kernel shell_history enabled -kernel shell_history_path '\"$HOME/.erl_history\"'"

# Elixir build container
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} as builder

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev git
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
COPY . /build
WORKDIR /build

RUN mix deps.clean --all && mix deps.get
RUN mix release nerves_hub_ca --overwrite

# Release Container
FROM nerveshub/runtime:alpine-${ALPINE_VERSION} as release

ENV HOST=${CA_NERVES_HOST}
ENV DATABASE_URL=${DATABASE_URL}

EXPOSE 8443

WORKDIR /app

COPY --from=builder /build/_build/$MIX_ENV/rel/nerves_hub_ca/ ./
# COPY --from=builder /build/rel/scripts/s3-entrypoint.sh .

# RUN ["chmod", "+x", "/app/s3-entrypoint.sh"]

# ENTRYPOINT ["/app/s3-entrypoint.sh"]
CMD ["./bin/nerves_hub_ca", "start"]
