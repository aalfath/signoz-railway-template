# ClickHouse for SigNoz, with an embedded ClickHouse Keeper (single node).
# Same version SigNoz Foundry ships (25.12.5). Version and digest pinned.
FROM clickhouse/clickhouse-server:25.12.5@sha256:cacf32d6884291dc2ff5e0156a97f46fc53ff7c929a7906d114e268a929dfd3a

# SigNoz's histogramQuantile UDF (github.com/SigNoz/signoz releases, histogram-quantile/v0.0.1), checksum-verified.
ARG TARGETARCH
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    case "$arch" in \
      amd64) sum=33997073eb6d82b7be4f27f9fc8ec9e28a395e0f20674d5d54bb2fa28a75488d ;; \
      arm64) sum=e5605ebffa82a450ebbcdf6cf19dad546e1e40d52dbf3e03cfd2d2d5b7394211 ;; \
      *) echo "unsupported arch $arch"; exit 1 ;; \
    esac; \
    cd /tmp; \
    wget -q -O hq.tgz "https://github.com/SigNoz/signoz/releases/download/histogram-quantile%2Fv0.0.1/histogram-quantile_linux_${arch}.tar.gz"; \
    echo "$sum  hq.tgz" | sha256sum -c -; \
    tar -xzf hq.tgz histogram-quantile; \
    mkdir -p /etc/clickhouse-server/user_scripts; \
    mv histogram-quantile /etc/clickhouse-server/user_scripts/histogramQuantile; \
    chmod 0755 /etc/clickhouse-server/user_scripts/histogramQuantile; \
    rm -f hq.tgz

COPY config.d/ /etc/clickhouse-server/config.d/
COPY custom_function.xml /etc/clickhouse-server/custom_function.xml

# The stock entrypoint creates the password-protected user from
# CLICKHOUSE_USER / CLICKHOUSE_PASSWORD and chowns the Railway volume.
ENV CLICKHOUSE_USER=signoz \
    CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1

ENTRYPOINT ["/entrypoint.sh"]
