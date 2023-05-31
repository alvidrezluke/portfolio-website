FROM rust:1.69.0 as build

COPY . .

RUN cargo build --release

FROM alpine:latest

COPY --from=build ./target/release/portfolio-website ./portfolio-website

EXPOSE 8080
#CMD ["./portfolio-website"]

