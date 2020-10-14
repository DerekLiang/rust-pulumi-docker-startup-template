FROM rust:1.43 as builder

RUN USER=root cargo new --bin docker_web
WORKDIR ./docker_web
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs

ADD . ./

RUN rm ./target/release/deps/docker_web*
RUN cargo build --release


FROM debian:buster-slim
ARG APP=/usr/src/app

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

ENV TZ=Etc/UTC \
    APP_USER=appuser

RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP}

COPY --from=builder /docker_web/target/release/docker_web ${APP}/docker_web

RUN chown -R $APP_USER:$APP_USER ${APP}
# RUN apt-get install -y libcap && setcap 'cap_net_bind_service=+ep' ${APP}/docker_web

USER $APP_USER
WORKDIR ${APP}

CMD ["./docker_web"]