# syntax=docker/dockerfile:1.2
FROM clux/muslrust:1.64.0 as builder

WORKDIR /src
RUN git clone --depth 1 --branch v0.9.3 https://github.com/playit-cloud/playit-agent playit-agent
WORKDIR /src/playit-agent
RUN cargo build --release

FROM scratch
COPY --from=builder /src/playit-agent/target/x86_64-unknown-linux-musl/release/agent /bin/agent
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/bin/agent", "-s", "-c", "/etc/playit/playit.toml"]