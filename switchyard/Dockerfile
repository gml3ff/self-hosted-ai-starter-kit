# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Based on the upstream Switchyard Dockerfile, with our routes.toml baked in
# so no runtime bind-mount is needed (this image is built and run against a
# remote Docker daemon, where local-machine paths don't resolve).

ARG RUST_VERSION=1.96.1
FROM rust:${RUST_VERSION}-bookworm AS builder

WORKDIR /opt/switchyard
COPY Cargo.toml Cargo.lock rust-toolchain.toml ./
COPY .cargo ./.cargo
COPY crates ./crates

RUN cargo build --locked --release -p switchyard-server

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder \
    /opt/switchyard/target/release/switchyard-server \
    /usr/local/bin/switchyard-server

COPY routes.toml /etc/switchyard/routes.toml

ENV HOME=/tmp

USER 1000:1000
EXPOSE 4000

ENTRYPOINT ["switchyard-server"]
CMD ["--config", "/etc/switchyard/routes.toml", "--host", "0.0.0.0", "--port", "4000"]
