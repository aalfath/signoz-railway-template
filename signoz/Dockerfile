# SigNoz UI + query service. Version and digest pinned; bump both together.
FROM signoz/signoz:v0.150.0@sha256:f47f90603c34667667bfdc17c58fcc7dd6986256a3164d288192e076aa84e3a6

# Fixed settings (Railway variables only carry references and secrets).
ENV SIGNOZ_SQLSTORE_PROVIDER=sqlite \
    SIGNOZ_SQLSTORE_SQLITE_PATH=/var/lib/signoz/signoz.db \
    SIGNOZ_TELEMETRYSTORE_PROVIDER=clickhouse \
    SIGNOZ_TELEMETRYSTORE_CLICKHOUSE_CLUSTER=cluster \
    SIGNOZ_ALERTMANAGER_PROVIDER=signoz

COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
