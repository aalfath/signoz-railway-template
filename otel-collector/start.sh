#!/bin/sh
# Railway wrapper for the SigNoz collector:
# 1. wait for ClickHouse, 2. apply the SigNoz schema migrations (idempotent),
# 3. start the collector with OpAMP pointed at the SigNoz service.
set -eu
: "${SIGNOZ_OTEL_COLLECTOR_CLICKHOUSE_DSN:?SIGNOZ_OTEL_COLLECTOR_CLICKHOUSE_DSN must point at the ClickHouse service}"
: "${OTLP_INGEST_TOKEN:?OTLP_INGEST_TOKEN must be set (bearer token for the public OTLP/HTTP endpoint)}"
BIN=/signoz-otel-collector

i=0
until $BIN migrate ready --timeout 10s >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 120 ]; then echo "[railway] ClickHouse not ready after 10 minutes" >&2; exit 1; fi
  echo "[railway] waiting for ClickHouse ($i)..."
  sleep 5
done

echo "[railway] applying SigNoz schema migrations"
$BIN migrate bootstrap
$BIN migrate sync up
$BIN migrate async up

ARGS="--config=/etc/otel/railway-config.yaml --copy-path=/tmp/collector-config.yaml"
if [ -n "${SIGNOZ_OPAMP_HOST:-}" ]; then
  printf 'server_endpoint: ws://%s:4320/v1/opamp\n' "$SIGNOZ_OPAMP_HOST" > /tmp/opamp.yaml
  ARGS="$ARGS --manager-config=/tmp/opamp.yaml"
fi
echo "[railway] starting collector"
# shellcheck disable=SC2086
exec $BIN $ARGS
