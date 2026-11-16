# SigNoz OpenTelemetry Collector (ingester). It also runs the ClickHouse schema
# migrations before it starts, so no separate migrator service is needed.
FROM signoz/signoz-otel-collector:v0.144.15@sha256:3996e0ffc58bc86d433062a45ef7ff960a4768da0619944f651a17254d634daf

ENV LOW_CARDINAL_EXCEPTION_GROUPING=false \
    SIGNOZ_OTEL_COLLECTOR_TIMEOUT=10m \
    SIGNOZ_OTEL_COLLECTOR_CLICKHOUSE_CLUSTER=cluster \
    SIGNOZ_OTEL_COLLECTOR_CLICKHOUSE_REPLICATION=true

COPY --chmod=0644 config.yaml /etc/otel/railway-config.yaml
COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/railway-start.sh"]
