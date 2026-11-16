# Changelog

## 2026-11-16: SigNoz v0.150.0

First release of the template.

**Breaking changes:** none (first release).

- SigNoz `v0.150.0` (`signoz/signoz@sha256:f47f90603c34667667bfdc17c58fcc7dd6986256a3164d288192e076aa84e3a6`), SQLite metadata on a volume.
- SigNoz OpenTelemetry Collector `v0.144.15` (`signoz/signoz-otel-collector@sha256:3996e0ffc58bc86d433062a45ef7ff960a4768da0619944f651a17254d634daf`), config from SigNoz Foundry plus bearer-token auth on OTLP/HTTP. Runs `migrate bootstrap`, `sync up` and `async up` before it starts.
- ClickHouse `25.12.5` (`clickhouse/clickhouse-server@sha256:cacf32d6884291dc2ff5e0156a97f46fc53ff7c929a7906d114e268a929dfd3a`) with embedded ClickHouse Keeper, a password-protected `signoz` user and SigNoz's `histogramQuantile` UDF (`histogram-quantile/v0.0.1`, checksum-verified).
- SigNoz v0.150.0 notes from upstream: alert rules move to the `v2alpha1` schema, and log bodies are dual-ingested as native JSON (more collector and ClickHouse CPU and log disk). See https://signoz.io/docs/operate/migration/upgrade-0-150/.
