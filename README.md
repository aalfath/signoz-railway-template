[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/signoz-3?utm_medium=integration&utm_source=button&utm_campaign=signoz)

# SigNoz on Railway

A Railway template for [SigNoz](https://github.com/SigNoz/signoz), the open-source, OpenTelemetry-native observability platform: traces, metrics and logs in one UI, stored in ClickHouse.

## What it deploys

| Service | Folder | Upstream image (pinned by version and digest) | Purpose |
|---|---|---|---|
| **SigNoz** | `signoz/` | `signoz/signoz:v0.150.0` | UI, query service, alerts. Public on a Railway domain. Volume `/var/lib/signoz` (SQLite metadata: users, dashboards, alerts) |
| **Collector** | `otel-collector/` | `signoz/signoz-otel-collector:v0.144.15` | OpenTelemetry Collector. Runs the SigNoz ClickHouse schema migrations at start, then receives OTLP. Public OTLP/HTTP domain (port 4318) protected by a bearer token; OTLP/gRPC 4317 on the private network |
| **ClickHouse** | `clickhouse/` | `clickhouse/clickhouse-server:25.12.5` | Telemetry store with an embedded ClickHouse Keeper (no ZooKeeper) and SigNoz's `histogramQuantile` function. Private network only. Volume `/var/lib/clickhouse` |

Every service builds from this repo, so Railway offers deployers an update when `main` changes.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| ClickHouse | `CLICKHOUSE_PASSWORD` | generated, 32 characters | Password of the `signoz` ClickHouse user (the passwordless `default` user is removed) |
| Collector | `OTLP_INGEST_TOKEN` | generated, 48 characters | Bearer token your apps send to the public OTLP/HTTP endpoint |
| Collector | `SIGNOZ_OTEL_COLLECTOR_CLICKHOUSE_DSN` | built from the ClickHouse service | |
| Collector | `SIGNOZ_OPAMP_HOST` | `${{SigNoz.RAILWAY_PRIVATE_DOMAIN}}` | Lets SigNoz push log pipelines to the collector |
| SigNoz | `SIGNOZ_TELEMETRYSTORE_CLICKHOUSE_DSN` | built from the ClickHouse service | |
| SigNoz | `SIGNOZ_GLOBAL_EXTERNAL__URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL of the UI (used in alert links) |
| SigNoz | `SIGNOZ_GLOBAL_INGESTION__URL` | `https://${{Collector.RAILWAY_PUBLIC_DOMAIN}}` | Shown in SigNoz's onboarding screens |
| each | `PORT` | 8080 / 13133 / 8123 | Port Railway's health check probes |

Nothing needs to be filled in at deploy time. Optional settings such as SMTP for alert emails (`SIGNOZ_EMAILING_*`) are SigNoz environment variables you can add later; see the [SigNoz configuration reference](https://github.com/SigNoz/signoz/blob/v0.150.0/conf/example.yaml) (`SIGNOZ_` + the YAML path, `_` between levels, `__` for an underscore in a key).

## First steps

1. Open the SigNoz service's public URL and create the first account. That account becomes the admin, and self-registration closes after it.
2. Send telemetry. From another Railway service, use OTLP/gRPC `http://${{Collector.RAILWAY_PRIVATE_DOMAIN}}:4317` (no token needed on the private network). From outside Railway, use OTLP/HTTP:

   ```sh
   OTEL_EXPORTER_OTLP_ENDPOINT=https://YOUR-COLLECTOR-DOMAIN
   OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
   OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer YOUR-OTLP_INGEST_TOKEN"
   ```

## Updates

The upstream versions are pinned in each folder's `Dockerfile`. When we bump them, Railway shows deployers an "update available" notice; read [`CHANGELOG.md`](CHANGELOG.md) before you apply it (breaking changes are listed first). Railway redeploys each service with its volume, and the collector applies any new ClickHouse schema migrations when it starts.

## Local test

```sh
docker compose -f test/compose.yaml up --build   # see test/compose.yaml for the variables it expects
```
