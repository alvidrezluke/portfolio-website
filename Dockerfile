FROM rust:1.69.0 as build

WORKDIR /usr/src/portfolio-website
COPY . .

RUN cargo install --path .

FROM alpine:latest

COPY --from=build /usr/local/cargo/bin/portfolio-website /usr/local/bin/portfolio-website

CMD ["portfolio-website"]
