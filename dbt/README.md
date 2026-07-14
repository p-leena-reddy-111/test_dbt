# Sample dbt Project

This is a small, runnable dbt Core sample project designed for local learning and experimentation.

It uses `dbt-duckdb` so you can run the full project locally without Snowflake, BigQuery, Databricks, or Redshift.

## What is included

- local `profiles.yml` for sample-only usage
- seeds that act as raw input data
- dbt source definitions over the raw seeded layer
- staging models
- an incremental fact model
- a dimension model
- a reporting mart
- schema tests and a singular test
- a snapshot example
- monitoring macros that store test results and source/bronze row counts

## Project layout

```text
dbt/
  analyses/
  macros/
  models/
    staging/
    marts/
  seeds/
  snapshots/
  tests/
  dbt_project.yml
  profiles.yml
```

## Prerequisites

Install Python, then create a virtual environment and install dbt.

```bash
python -m venv .venv
.venv\Scripts\activate
pip install dbt-core dbt-duckdb
```

## Run the sample

Run these commands from this folder:

```bash
dbt debug --profiles-dir .
dbt seed --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt snapshot --profiles-dir .
dbt docs generate --profiles-dir .
```

After `dbt run`, `dbt test`, or `dbt build`, the project also writes monitoring data to:

- `analytics_monitoring.dbt_test_results`
- `analytics_monitoring.dbt_row_counts`

You can turn those raw row-count records into a reconciliation-style summary with the model:

- `monitoring_source_to_bronze_validation`

In this sample:

- `source` counts come from dbt source definitions over the raw seeded layer
- `bronze` counts come from models tagged `bronze`, which is the staging layer in this project

## Why the profile is in the project

For a real production setup, `profiles.yml` should live outside the repository and secrets should come from environment variables or a secrets manager.

For this sample project, the profile is committed locally so the project is easy to run and study.

## What to study first

1. `models/staging/` to see basic standardization patterns.
2. `models/marts/fct_orders.sql` to see an incremental model.
3. `models/marts/mart_customer_order_summary.sql` to see downstream aggregation.
4. `snapshots/customer_tiers_snapshot.sql` to see SCD-style history capture.

## Suggested next steps

1. Add a source-based raw layer instead of seeds.
2. Replace DuckDB with your target warehouse adapter.
3. Add CI with `dbt parse`, `dbt build`, and state-based selection.