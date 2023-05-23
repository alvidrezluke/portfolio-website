FROM rust:1.43 as builder
RUN USER=root cargo new --bin portfolio-website
WORKDIR ./portfolio-website
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs

ADD . ./

RUN rm ./target/release/deps/portfolio_website*
RUN cargo build --release

FROM debian:buster-slim
ARG APP=/usr/src/app

RUN apt-get-update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8001

ENV TZ=Etc/UTC \
    APP_USER=appuser

RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP}

COPY --from=builder /portfolio-website/target/release/portfolio-website ${APP}/portfolio-website

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER

WORKDIR ${APP}

CMD ["./portfolio-website"]
