FROM rust:1.69.0 as build

# Create an empty shell project
RUN USER=root cargo new --bin portfolio-website
WORKDIR /portfolio-website

# Copy manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# Build step to cache dependencies
RUN cargo build --release
RUN rm src/*.rs

# Copy source tree
COPY ./src ./src

# Build for release
RUN rm./target/release/deps/portfolio-website*
RUN cargo build --release

FROM debian:buster-slim

COPY --from=build portfolio-website/target/release/portfolio-website .

CMD ["./portfolio-website"]

