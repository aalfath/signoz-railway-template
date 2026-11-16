#!/bin/sh
# Railway wrapper for SigNoz: listen on $PORT and keep the metadata DB on the volume.
set -eu
: "${SIGNOZ_TELEMETRYSTORE_CLICKHOUSE_DSN:?SIGNOZ_TELEMETRYSTORE_CLICKHOUSE_DSN must point at the ClickHouse service}"
mkdir -p /var/lib/signoz
export SIGNOZ_APISERVER_ADDRESS=":${PORT:-8080}"
# Alert links point at the public URL when it is known.
if [ -n "${SIGNOZ_GLOBAL_EXTERNAL__URL:-}" ] && [ -z "${SIGNOZ_ALERTMANAGER_SIGNOZ_EXTERNAL__URL:-}" ]; then
  export SIGNOZ_ALERTMANAGER_SIGNOZ_EXTERNAL__URL="$SIGNOZ_GLOBAL_EXTERNAL__URL"
fi
cd /root
exec ./signoz server
